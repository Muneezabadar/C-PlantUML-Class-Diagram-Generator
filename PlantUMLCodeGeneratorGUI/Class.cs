﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace PlantUMLCodeGeneratorGUI
{
    static class RegExs
    { 
        public static Regex namespaceMatch = new Regex(@"(namespace)([ \t]+)([a-zA-Z0-9_:]+)([ \t\r\n]*{)");
        public static Regex classMatch = new Regex(@"([ \t]*)((class|struct)[ \t]+)([A-Z_0-9]+[ \t]+)?(?<classname>[a-zA-Z0-9_]+)(?<parentstr>([ \t]*:[ \t]*(((public|private|protected)[ \t]+)?(([a-zA-Z0-9_]+::[a-zA-Z0-9_<>]+)+|([a-zA-Z0-9_<>]+))))([ \t\r\n]*,[ \t\r\n]*((public|private|protected)[ \t]+)*(([a-zA-Z0-9_]+::[a-zA-Z0-9_]+)+|([a-zA-Z0-9_<>]+)))*|)([ \t\r\n]*[{])");
        public static Regex methodMatch = new Regex(@"(([ \t]+)([a-zA-Z0-9_:,<>\*]+))+([ \t]*\()((([ \t]*)(([a-zA-Z0-9_:]+[&*]?[ \t]+[a-zA-Z0-9_]+)(,[ \t]*[a-zA-Z0-9_:]+[&*]?[ \t]+[a-zA-Z0-9_]+))|)(\)[ \t\r\n]*([{;=]|override|const)))");
        public static Regex multiSpaces = new Regex("[ ]{2,}", RegexOptions.None);
    }

    class StringifiedContent
    {
        public readonly string ClassContent;
        public readonly string ClassConnectivityContent;

        public StringifiedContent(string classContent, string classRelationshipsContent)
        {
            ClassContent = classContent;
            ClassConnectivityContent = classRelationshipsContent;
        }
    }

    class Namespace
    {
        public string Name;
        public Namespace ParentNamespace;
        public List<Namespace> ChildNamespaces;
        public Dictionary<string, Namespace> Namespaces;        
        public Dictionary<string, Class> Classes;

        public string FullName
        {
            get
            {
                var parentNamespace = this;
                var fullName = "";
                while (parentNamespace != null)
                {
                    fullName = parentNamespace.Name + (fullName.Length == 0 ? "" : "::") + fullName;
                    parentNamespace = parentNamespace.ParentNamespace;
                }

                return fullName;
            }
        }

        private Namespace(Namespace parentNamespace, string name)
        {
            Name = name;
            ParentNamespace = parentNamespace;

            if (ParentNamespace != null) ParentNamespace.AddChild(this);

            ChildNamespaces = new List<Namespace>();
            Namespaces = new Dictionary<string, Namespace>();
            Classes = new Dictionary<string, Class>();
        }

        private void AddChild(Namespace childNamespace)
        {
            ChildNamespaces.Add(childNamespace);
        }

        public void Set(string namespaceContent)
        {
            frmLoadingDialog.UpdateProgressText("Processing Class : " + FullName);
            var remainingContent = "";

            var matches = RegExs.namespaceMatch.Matches(namespaceContent);
            var lastMatchOffset = 0;

            foreach (Match match in matches)
            {
                var matchIndex = match.Index;
                if (matchIndex < lastMatchOffset) continue;

                remainingContent += namespaceContent.Substring(lastMatchOffset, match.Index - lastMatchOffset);

                var innerNamespaceContent = Processor.GetScopedContent(namespaceContent, ref matchIndex);
                var namespaceName = match.Groups[3].Value;
                lastMatchOffset = match.Index + match.Length + innerNamespaceContent.Length + 1;

                var namespaceObj = namespaceName.Contains("::") ? GetNamespace(namespaceName) : GetNamespace(this, namespaceName);
                namespaceObj.Set(innerNamespaceContent);

                if (Namespaces.ContainsKey(namespaceObj.Name) == false) Namespaces.Add(namespaceObj.Name, namespaceObj);
            }

            remainingContent = namespaceContent.Substring(lastMatchOffset, namespaceContent.Length - lastMatchOffset);

            remainingContent = ProcessFullContent(remainingContent);
        }

        private string ProcessFullContent(string fullContent)
        {
            var remainingContent = "";
            var offset = 0;

            if (fullContent.Contains("Transaction"))
                Console.WriteLine();

            var classMatches = RegExs.classMatch.Matches(fullContent);
            foreach (Match classMatch in classMatches)
            {
                if (classMatch.Index < offset) continue;

                remainingContent += fullContent.Substring(offset, classMatch.Index - offset);

                var matchOffset  = classMatch.Index;
                var classContent = Processor.GetScopedContent(fullContent, ref matchOffset);
                var classObj     = Class.GetClass(this, classMatch.Groups["classname"].Value);

                offset       = matchOffset;
                classContent = ProcessFullContent(classContent);

                classObj.Set(classContent);

                var parentStr = classMatch.Groups["parentstr"].Value;
                if (string.IsNullOrEmpty(parentStr)) continue;

                parentStr = parentStr.Replace("::", "[--]").Replace(":", "").Replace("[--]", "::").Trim();

                var parentNames = parentStr.Trim().Split(',');
                foreach (var parent in parentNames)
                {
                    bool isPrivate = false;
                    bool isPublic = false;

                    if (parent.Contains("private ")) isPrivate = true;
                    else if (parent.Contains("public ")) isPublic = true;
                    else if (parent.Contains("protected ") == false) isPrivate = true;

                    var parentName = parent.Replace("private", "").Replace("public", "").Replace("protected", "").Trim().Replace(" ", "").Replace("\t", "");

                    var parentClassObj = parentName.Contains("::") ? Class.GetClass(parentName) : Class.GetClass(this, parentName);
                    (isPrivate ? classObj.PrivateScope : (isPublic ? classObj.PublicScope : classObj.ProtectedScope)).Parents.Add(parentClassObj);
                }
            }

            remainingContent += fullContent.Substring(offset);
            return remainingContent;
        }

        public StringifiedContent ToString(Settings settings)
        {
            var namespaceContent = "";
            var classConnectivityContent = "";

            namespaceContent += "package " + Name + " {" + Environment.NewLine;

            foreach (var ns in Namespaces)
            {
                var stringifiedContent = ns.Value.ToString(settings);

                namespaceContent += "\t" + (stringifiedContent.ClassContent.Trim()).Replace(Environment.NewLine, Environment.NewLine + "\t").Trim();
                namespaceContent += Environment.NewLine;
                namespaceContent += Environment.NewLine;

                if (stringifiedContent.ClassConnectivityContent.Any())
                {
                    classConnectivityContent += stringifiedContent.ClassConnectivityContent;
                    classConnectivityContent += Environment.NewLine;
                    classConnectivityContent += Environment.NewLine;
                }
            }

            namespaceContent = namespaceContent.Trim();
            namespaceContent += Environment.NewLine;

            if (Classes.Any() && Namespaces.Any())
                namespaceContent += Environment.NewLine;

            for (int a = 0; a < Classes.Count; a++)
            {
                var cs = Classes[Classes.Keys.ToArray()[a]];
                var stringifiedContent = cs.ToString(settings);

                namespaceContent += "\t" + (stringifiedContent.ClassContent.Trim()).Replace(Environment.NewLine, Environment.NewLine + "\t").Trim();
                namespaceContent += Environment.NewLine;
                namespaceContent += Environment.NewLine;

                if (stringifiedContent.ClassConnectivityContent.Any())
                {
                    classConnectivityContent += stringifiedContent.ClassConnectivityContent;
                    classConnectivityContent += Environment.NewLine;
                    classConnectivityContent += Environment.NewLine;
                }
            }

            namespaceContent = namespaceContent.Trim();
            namespaceContent += Environment.NewLine;
            namespaceContent += "}";

            return new StringifiedContent(namespaceContent.Trim(), classConnectivityContent.Trim());
        }

        public static Namespace GetNamespace(Namespace parentNamespace, string namespaceName)
        {
            return GetNamespace(parentNamespace.FullName + "::" + namespaceName);
        }

        public static Namespace GetNamespace(string fullNameIncludingNamespace, bool justCheck = false)
        {
            var parentNamespace = DefaultNamespace;
            var namespaceNames = fullNameIncludingNamespace.Split(new []{"::"}, StringSplitOptions.None);
            foreach (var namespaceName in namespaceNames)
            {
                if (namespaceName == DefaultNamespace.Name) continue;

                Namespace foundNamespace;
                parentNamespace.Namespaces.TryGetValue(namespaceName, out foundNamespace);
                if (foundNamespace  == null)
                {
                    if (justCheck)
                    {
                        return null;
                    }

                    foundNamespace = new Namespace(parentNamespace, namespaceName);
                    parentNamespace.Namespaces.Add(namespaceName, foundNamespace);
                }

                parentNamespace = foundNamespace;
            }

            return parentNamespace;
        }

        public static void ResetDefaultNamespace()
        {
            DefaultNamespace = new Namespace(null, "DefaultNamespace");
        }

        public static Namespace DefaultNamespace = new Namespace(null, "DefaultNamespace");
    }

    class Class
    {
        public Namespace ParentNamespace;
        public string Name { get; internal set; }
        public string FullName { get { return ParentNamespace.FullName + "::" + Name; } }

        public Scope PublicScope { get; internal set; }
        public Scope ProtectedScope { get; internal set; }
        public Scope PrivateScope { get; internal set; }

        public bool IsInterface { get; internal set; }

        private Class(Namespace parentNamespace, string name)
        {
            ParentNamespace = parentNamespace;
            Name = name;

            PublicScope = new Scope("public");
            ProtectedScope = new Scope("protected");
            PrivateScope = new Scope("private");
        }

        public static Class GetClass(Namespace namespaceObj, string className, bool justCheck = false)
        {
            if (className == "loaderLoader")
            {
                Console.WriteLine();
            }
            Class foundClass = null;
            if (namespaceObj.Classes.TryGetValue(className, out foundClass) == false)
            {
                if (justCheck)
                {
                    foreach (var childNamespace in namespaceObj.ChildNamespaces)
                    {
                        foundClass = GetClass(childNamespace, className, true);
                        if (foundClass != null) break;
                    }

                    return foundClass;
                }

                foundClass = new Class(namespaceObj, className);
                namespaceObj.Classes.Add(foundClass.Name, foundClass);
            }

            return foundClass;
        }

        public static Class GetClass(string fullName, bool justCheck = false)
        {
            var namespaceName = fullName.Substring(0, fullName.LastIndexOf("::", StringComparison.Ordinal));
            var className = fullName.Substring(fullName.LastIndexOf("::", StringComparison.Ordinal) + 2);

            return GetClass(namespaceName, className, justCheck);
        }

        public static Class GetClass(string namespaceName, string className, bool justCheck = false)
        {
            var namespaceObj = Namespace.GetNamespace(namespaceName, justCheck);
            if (justCheck && namespaceObj == null)
            {
                return null;
            }

            return GetClass(namespaceObj, className, justCheck);
        }

        private List<string> GetScopedSegments(string classContent, Scope[] scopes)
        {
            var segments = new List<string>();
            var lastIndexChecked = 0;

            while (true)
            {
                var matchingIndices = scopes.Select(i => new Regex(i.Name + "[ \t]*:").Match(classContent, lastIndexChecked + 1)).Where(i => i.Success).ToArray();
                if (matchingIndices.Any() == false) break;

                var orderedScopes = matchingIndices.OrderBy(i => i.Index);
                var scopeEnd = orderedScopes.First();

                segments.Add(classContent.Substring(lastIndexChecked, scopeEnd.Index - lastIndexChecked));

                lastIndexChecked = scopeEnd.Index;
            }

            segments.Add(classContent.Substring(lastIndexChecked, classContent.Length - lastIndexChecked - 1).Trim());

            return segments.Where(i => i.Length > 0).ToList();
        }

        public void Set(string classContent)
        {
            frmLoadingDialog.UpdateProgressText("Processing Class : " + ParentNamespace.FullName + Name);
            var scopes = new [] { PublicScope, PrivateScope, ProtectedScope };
            var segments = GetScopedSegments(classContent, scopes);

            var scopeData = new Dictionary<string, string>();
            foreach (var segment in segments)
            {
                var scopeName = "private";
                var matchingScopes = scopes.Where(i => segment.StartsWith(i.Name)).ToArray();
                if (matchingScopes.Any())
                {
                    scopeName = matchingScopes.First().Name;
                }

                if (scopeData.ContainsKey(scopeName) == false)
                    scopeData.Add(scopeName, "");

                scopeData[scopeName] += Environment.NewLine + segment.Substring(matchingScopes.Any() ? (segment.IndexOf(":", StringComparison.Ordinal) + 1) : 0);
            }

            foreach (var scope in scopes)
            {
                var scopeContent = "";
                if (scopeData.TryGetValue(scope.Name, out scopeContent) == false) continue;

                if (scopeContent.Contains("BatchAckHandlerEvent"))
                    Console.WriteLine();

                var visitedIndex = 0;

                while (visitedIndex < scopeContent.Length - 1)
                {
                    var indexOfCurlyBracket = scopeContent.IndexOf("{", visitedIndex + 1, StringComparison.Ordinal);
                    var indexOfSemiColon = scopeContent.IndexOf(";", visitedIndex + 1, StringComparison.Ordinal);

                    var orderedIndices = new[] {indexOfSemiColon, indexOfCurlyBracket}.Where(i => i != -1).ToArray();
                    if (orderedIndices.Any() == false) break;

                    var nextToVisitIndex = orderedIndices.OrderBy(i => i).First();
                    if (nextToVisitIndex == -1) break;

                    var methodContent = scopeContent.Substring(visitedIndex, nextToVisitIndex - visitedIndex).Trim();

                    if (nextToVisitIndex == indexOfCurlyBracket)
                    {
                        var offset = indexOfCurlyBracket;
                        var scopedContent = Processor.GetScopedContent(scopeContent, ref offset);
                        visitedIndex = offset;

                        if (methodContent.StartsWith("struct"))
                        {
                            var indexOfInnerSemiColon = scopeContent.IndexOf(";", visitedIndex, StringComparison.Ordinal) + 1;
                            
                            if (indexOfInnerSemiColon != -1)
                                visitedIndex = indexOfInnerSemiColon;
                        }
                    }
                    else
                    {
                        visitedIndex = nextToVisitIndex + 1;
                    }

                    methodContent = RegExs.multiSpaces.Replace(methodContent.Replace("\r\n", "").Replace("\n", "").Replace("\t", " "), " ");

                    var argStartBracket = methodContent.IndexOf("(", StringComparison.Ordinal);
                    var argEndBracket = methodContent.IndexOf(")", StringComparison.Ordinal);

                    if (argStartBracket != -1 && argEndBracket != -1) // This is a method
                    {
                        if (methodContent.Contains(" operator()") || methodContent.Contains(" operator ()"))
                        {
                            argStartBracket = methodContent.IndexOf("(", argEndBracket + 1, StringComparison.Ordinal);
                            argEndBracket = methodContent.IndexOf(")", argEndBracket + 1, StringComparison.Ordinal);
                        }

                        var indexOfColon = methodContent.IndexOf(":", argEndBracket, StringComparison.Ordinal);
                        if (indexOfColon != -1 && indexOfColon < nextToVisitIndex)
                        {
                            methodContent = methodContent.Substring(0, indexOfColon).Trim();
                        }

                        var isOperatorOverload = methodContent.Contains(" operator");
                        var methodNameAndStuff = methodContent.Substring(0, argStartBracket).Replace("virtual", "").Replace("inline", "").Replace("static", "").Replace("~ ", "~").Replace("operator", "").Trim();
                        var indexOfSpace = methodNameAndStuff.LastIndexOf(" ", StringComparison.Ordinal);
                        var methodName = methodNameAndStuff.Substring(indexOfSpace + 1).Trim();
                        var methodReturn = indexOfSpace != -1 ? methodNameAndStuff.Substring(0, indexOfSpace).Trim() : null;
                        var arguments = methodContent.Substring(argStartBracket + 1, argEndBracket - argStartBracket - 1).Split(',');

                        var method = new Method
                        {
                            Name = methodName,
                            ReturnType = string.IsNullOrEmpty(methodReturn) ? null : new Member() { Type = methodReturn },
                            IsConstructor = methodName == Name,
                            IsDestructor = methodName == "~" + Name,
                            IsVirtual = methodContent.StartsWith("virtual "),
                            IsConst = methodContent.EndsWith("const"),
                            IsOverriding = methodContent.EndsWith("override"),
                            IsPureVirtual = methodContent.Replace(" ", "").EndsWith("=0"),
                            IsOperatorOverload = isOperatorOverload,
                            Owner = this
                        };

                        if (method.ReturnType == null && (method.IsConstructor == false && method.IsDestructor == false)) continue;

                        foreach (string tmpArgument in arguments)
                        {
                            var argument = tmpArgument;

                            if (string.IsNullOrEmpty(argument)) continue;

                            if (argument.Contains("=")) argument = argument.Substring(0, argument.IndexOf("=", StringComparison.Ordinal)).Trim();

                            var hasASpace    = argument.Contains(' ');
                            var argumentName = hasASpace ? argument.Split(' ').Last() : "";
                            var argumentType = hasASpace ? argument.Substring(0, argument.LastIndexOf(" ", StringComparison.Ordinal)).Trim() : argument;

                            method.Arguments.Add(new Member { Name = argumentName, Type = argumentType, OwnerClass = this, OwnerMethod = method });
                        }

                        scope.Methods.Add(method);
                    }
                    else if (argEndBracket == -1 && argStartBracket == -1 && nextToVisitIndex == indexOfSemiColon) // This is a variable
                    {
                        var memberContent = methodContent.Trim();
                        if (memberContent.Length == 0) continue;

                        if (memberContent.StartsWith("friend class") || memberContent.StartsWith("typedef")) continue;

                        memberContent = memberContent.Split('=').First().Trim();
                        var indexOfLastSpace = memberContent.LastIndexOf(" ", StringComparison.Ordinal);
                        var memberType = memberContent.Substring(0, indexOfLastSpace).Trim();
                        var memberName = memberContent.Substring(indexOfLastSpace + 1).Trim();

                        scope.Members.Add(new Member { Name = memberName, Type = memberType, OwnerClass = this });
                    }
                }
            }

            IsInterface = scopes.Any(i => i.Methods.Any(ii => ii.IsPureVirtual));
        }

        public StringifiedContent ToString(Settings settings)
        {
            var scopes = new List<Scope> { PublicScope };

            if (settings.IncludeProtectedMethodsAndMembers) scopes.Add(ProtectedScope);
            if (settings.IncludePrivateMethodsAndMembers)   scopes.Add(PrivateScope);

            string classContent = "";
            string classRelationshipsContent = "";

            classContent += (IsInterface ? "interface " : "class ") + Name + " {" + Environment.NewLine;

            foreach (var scope in scopes)
            {
                var prefix = ((scope == PublicScope) ? "+" : (scope == ProtectedScope ? "#" : "-"));

                foreach (var scopeMember in scope.Members)
                {
                    classContent += "\t" + prefix + scopeMember + Environment.NewLine;
                }

                foreach (var scopeMethod in scope.Methods.Where(i => (settings.IncludeOverridenMethods || i.IsOverriding == false) && i.IsOperatorOverload == false))
                {
                    classContent += "\t" + prefix + scopeMethod + Environment.NewLine;
                }
            }

            classContent += "}" + Environment.NewLine;

            if (scopes.Any()) 
                classContent += Environment.NewLine;

            foreach (var scope in scopes)
            {
                foreach (var scopeParent in scope.Parents)
                {
                    if (scopeParent.Name.Contains("<"))
                    {
                        var containerParentType = GetClass(ParentNamespace, scopeParent.Name.Substring(0, scopeParent.Name.IndexOf("<", StringComparison.Ordinal)));
                        var containedParentTypes = Processor.GetContainedTypes(scopeParent.Name, this);
                        foreach (var parentType in containedParentTypes)
                        {
                            classRelationshipsContent += Name + " ..|> " + parentType.Name + Environment.NewLine;
                        }

                        classRelationshipsContent += Name + " ..|> " + containerParentType.Name + Environment.NewLine; 
                    }
                    else
                    {
                        classRelationshipsContent += Name + " ..|> " + scopeParent.Name + Environment.NewLine; 
                    }
                }

                foreach (var referredType in scope.Members.Select(i => i.GetTypeAsClass()).Where(i => i != null).GroupBy(i => i))
                {
                    if (referredType.Any() == false) continue;

                    classRelationshipsContent += Name + " \"1\" *-- \"" + referredType.Count() + "\" " + referredType.Key.Name + Environment.NewLine;
                }

                foreach (var referredType in scope.Members.Select(i => i.GetContainedTypes()).SelectMany(i => i).Where(i => i != null).GroupBy(i => i))
                {
                    if (referredType.Any() == false) continue;

                    classRelationshipsContent += Name + " \"1\" -- \"" + referredType.Count() + "\" " + referredType.Key.Name + Environment.NewLine;
                }
            }

            return new StringifiedContent(classContent.Trim(), classRelationshipsContent.Trim());
        }
    }

    class Scope
    {
        public string Name;
        public List<Class> Parents { get; set; }
        public List<Member> Members { get; set; }
        public List<Method> Methods { get; set; }

        public Scope(string name)
        {
            Name = name;
            Parents = new List<Class>();
            Members = new List<Member>();
            Methods = new List<Method>();
        }
    }

    class Member
    {
        public string Type { get; internal set; }
        public string Name { get; internal set; }
        public Class OwnerClass { get; set; }
        public Method OwnerMethod { get; set; }

        private Class _type;
        private Class[] _containedTypes;

        public override string ToString()
        {
            return Name + " : " + Type;
            OwnerClass = null;
            OwnerMethod = null;
        }

        public Class GetTypeAsClass()
        {
            return _type ?? (_type = Processor.GetTypeAsClass(Type, OwnerClass));
        }

        public Class[] GetContainedTypes()
        {
            return _containedTypes ?? (_containedTypes = Processor.GetContainedTypes(Type, OwnerClass).ToArray());
        }
    }

    class Method
    {
        public bool IsConstructor { get; internal set; }
        public bool IsVirtual { get; internal set; }
        public bool IsOverriding { get; internal set; }
        public bool IsConst { get; internal set; }
        public bool IsPureVirtual { get; internal set; }
        public bool IsOperatorOverload { get; internal set; }
        public Member ReturnType { get; internal set; }
        public string Name { get; internal set; }
        public List<Member> Arguments { get; internal set; }
        public Class Owner { get; internal set; }
        public bool IsDestructor { get; set; }

        public Method()
        {
            Arguments = new List<Member>();
        }

        public override string ToString()
        {
            var argumentStr = Arguments.Aggregate(string.Empty, (a, b) => a.ToString() + ", " + b.ToString());
            if (argumentStr.Length > 0)
            {
                argumentStr = argumentStr.Substring(1).Trim();
            }

            return Name + "( " + argumentStr + (argumentStr.Length == 0 ? "" : " ") + ((ReturnType == null || string.IsNullOrEmpty(ReturnType.Type)) ? ")" : (") : " + ReturnType.Type));
        }
    }

    static class Macros
    {
        public static void Process(String content)
        {
            frmLoadingDialog.UpdateProgressText("Replacing macros...");

            var indexOfMacro = 0;
            var macroContents = new List<string>();
            while ((indexOfMacro = content.IndexOf("#define", indexOfMacro + 1, StringComparison.Ordinal)) != -1)
            {
                var indexOfEndOfMacro = indexOfMacro + 6;

                while (true)
                {
                    var indexOfEndOfLine = content.IndexOf("\n", indexOfEndOfMacro, StringComparison.Ordinal);
                    var indexOfEndOfBSlash = content.IndexOf("\\", indexOfEndOfMacro, StringComparison.Ordinal);

                    if (indexOfEndOfLine == -1)
                    {
                        macroContents.Add(content.Substring(indexOfMacro, content.Length - indexOfMacro - 1).Replace("\\", ""));
                        indexOfMacro = content.Length;
                        break;
                    }

                    if (indexOfEndOfBSlash == -1 || indexOfEndOfBSlash > indexOfEndOfLine)
                    {
                        macroContents.Add(content.Substring(indexOfMacro, indexOfEndOfLine - indexOfMacro).Replace("\\", ""));
                        indexOfMacro = indexOfEndOfLine;
                        break;
                    }

                    indexOfEndOfMacro = indexOfEndOfLine + 1;
                }
            }

            foreach (var macroContent in macroContents)
            {
                
            }
        }
    }

    struct Settings
    {
        public readonly bool IncludeOverridenMethods;
        public readonly bool IncludePrivateMethodsAndMembers;
        public readonly bool IncludeProtectedMethodsAndMembers;

        public Settings(bool includeOverridenMethods, bool includePrivateMethodsAndMembers, bool includeProtectedMethodsAndMembers)
        {
            IncludeOverridenMethods = includeOverridenMethods;
            IncludePrivateMethodsAndMembers = includePrivateMethodsAndMembers;
            IncludeProtectedMethodsAndMembers = includeProtectedMethodsAndMembers;
        }
    }

    static class Processor
    {

        public enum ScopeCharacterType
        {
            Parentheses = '(',
            AngleBrackets = '<',
            Braces = '{'
        }

        public static string Process(String fileContent, Settings settings)
        {
            Namespace.ResetDefaultNamespace();

            Macros.Process(fileContent);
            fileContent = RemoveComments(fileContent);
            fileContent = Cleanup(fileContent);

            Namespace.DefaultNamespace.Set(fileContent);

            var stringifiedContent = Namespace.DefaultNamespace.ToString(settings);
            return stringifiedContent.ClassContent + Environment.NewLine + Environment.NewLine + stringifiedContent.ClassConnectivityContent;
        }

        private static string Cleanup(String content)
        {
            var regexEnumClass = new Regex("enum[ \t]+class ");
            return regexEnumClass.Replace(content, "enum ");
        }

        public static string GetScopedContent(String completeContent, ref int offset, ScopeCharacterType scopeCharacterType = ScopeCharacterType.Braces)
        {
            var startCharacterType = "";
            var endCharacterType = "";

            if (scopeCharacterType == ScopeCharacterType.Braces)
            {
                startCharacterType = "{";
                endCharacterType = "}";
            }
            else if (scopeCharacterType == ScopeCharacterType.AngleBrackets)
            {
                startCharacterType = "<";
                endCharacterType = ">";
            }
            else if (scopeCharacterType == ScopeCharacterType.Parentheses)
            {
                startCharacterType = "(";
                endCharacterType = ")";
            }

            var methodContent = completeContent.Substring(offset);
            var indexofStartCharacterType = (methodContent.IndexOf(startCharacterType, StringComparison.Ordinal) + 1);

            offset += indexofStartCharacterType;
            methodContent = methodContent.Substring(indexofStartCharacterType);

            var numberOfClosingBrackets = 1;
            var indexToCheckFrom = 0;
            while (numberOfClosingBrackets > 0)
            {
                var indexOfOpeningBracket = methodContent.IndexOf(startCharacterType, indexToCheckFrom, StringComparison.Ordinal);
                var indexOfClosingBracket = methodContent.IndexOf(endCharacterType, indexToCheckFrom, StringComparison.Ordinal);

                if (indexOfOpeningBracket > indexOfClosingBracket || indexOfOpeningBracket == -1)
                {
                    indexToCheckFrom = indexOfClosingBracket + 1;
                    numberOfClosingBrackets--;
                }
                else
                {
                    indexToCheckFrom = indexOfOpeningBracket + 1;
                    numberOfClosingBrackets++;
                }
            }

            offset += (indexToCheckFrom);
            return methodContent.Substring(0, indexToCheckFrom - 1);
        }

        public static string RemoveComments(string completeContent)
        {
            frmLoadingDialog.UpdateProgressText("Cleaning-up comments...");

            var indexOfOneLineComment = -1;
            while ((indexOfOneLineComment = completeContent.IndexOf("//", StringComparison.Ordinal))!= -1)
            {
                var indexOfCRLF = completeContent.IndexOf("\r\n", indexOfOneLineComment, StringComparison.Ordinal);
                var indexofLF = completeContent.IndexOf("\n", indexOfOneLineComment, StringComparison.Ordinal);

                var indexOfNext = completeContent.Length;
                if (indexofLF != -1 && indexOfCRLF != -1)
                {
                    indexOfNext = Math.Min(indexofLF, indexOfCRLF);
                }
                else if (indexofLF != -1 ^ indexOfCRLF - 1 == 0)
                {
                    indexOfNext = Math.Max(indexofLF, indexOfCRLF);
                }

                completeContent = completeContent.Substring(0, indexOfOneLineComment) + completeContent.Substring(indexOfNext + 1);
            }

            var indexOfMultiLineComment = -1;
            while ((indexOfMultiLineComment = completeContent.IndexOf("/*", StringComparison.Ordinal)) != -1)
            {
                var indexOfMultiLineCommentClosing = completeContent.IndexOf("*/", indexOfMultiLineComment, StringComparison.Ordinal);

                completeContent = completeContent.Substring(0, indexOfMultiLineComment) + completeContent.Substring(indexOfMultiLineCommentClosing + 2);
            }

            return completeContent;
        }

        public static Class GetTypeAsClass(string type, Class ownerClass)
        {
            var tmpType = type;
            if (tmpType.Contains("<") && tmpType.Contains(">"))
            {
                tmpType = tmpType.Substring(0, tmpType.IndexOf("<", StringComparison.Ordinal)).Trim();
            }

            tmpType = tmpType.Replace("*", "").Replace("&", "").Replace("const ", "");
            if (tmpType.Contains("::"))
            {
                return Class.GetClass(tmpType, true);
            }

            return Class.GetClass(ownerClass.ParentNamespace, tmpType, true) ?? Class.GetClass(Namespace.DefaultNamespace, tmpType, true);
        }

        public static List<Class> GetContainedTypes(string type, Class ownerClass)
        {
            var indexOfOpeningAngledBrakcet = type.IndexOf("<", StringComparison.Ordinal);
            var indexOfClosingAngledBracket = type.LastIndexOf(">", StringComparison.Ordinal);

            if (type.Contains("BaseFactory"))
                Console.WriteLine();

            if (indexOfOpeningAngledBrakcet == -1 || indexOfClosingAngledBracket == -1)
            {
                return new List<Class>();
            }

            var containedTypes = new List<Class>();
            var containedTypesStr = type;
            containedTypesStr = containedTypesStr.Substring(indexOfOpeningAngledBrakcet + 1);
            containedTypesStr = containedTypesStr.Substring(0, indexOfClosingAngledBracket - indexOfOpeningAngledBrakcet - 1);

            var containedTypeStrings = containedTypesStr.Split(',').Select(i => i.Trim());
            foreach (var containedTypeStr in containedTypeStrings)
            {
                var currentType = containedTypeStr;
                var indexOfAngleBracket = containedTypeStr.IndexOf("<", StringComparison.Ordinal);
                if (indexOfAngleBracket != -1)
                {
                    containedTypes.AddRange(GetContainedTypes(currentType, ownerClass));
                    currentType = containedTypeStr.Substring(0, indexOfAngleBracket);
                }

                var foundType = GetTypeAsClass(currentType, ownerClass);
                if (foundType != null)
                {
                    containedTypes.Add(foundType);
                }
            }

            return containedTypes;
        }
    }
}
