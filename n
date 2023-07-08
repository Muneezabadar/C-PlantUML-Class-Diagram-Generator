#include <iostream>
#include <string>
#include <fstream>
using namespace std;

// Header Files
#include "menu.h"
#include "Validation.h"
#include "Sign_Password.h"
#include "Products.h"
#include "person.h"

// Classes
Validation User_Validtaion;
User user(Name_Memory, TellNum_Memory, Login_Memory, Password_Memory);

Class_Of_Products1 Product1_1("Potatoes", "Vegetables & Fruits", 7890.0, 10);
Class_Of_Products1 Product1_2("Carrots", "Vegetables & Fruits", 4890.0, 10);
Class_Of_Products1 Product1_3("Onion", "Vegetables & Fruits", 3600.0, 10);

Class_Of_Products2 Product2_1("Water", "Water & Beverages", 1590.0, 10);
Class_Of_Products2 Product2_2("Pepsi", "Water & Beverages", 3590.0, 10);
Class_Of_Products2 Product2_3("Nectar", "Water & Beverages", 7550.0, 10);

Class_Of_Products3 Product3_1("Pizza", "Fast Food Products", 48000.0, 10);
Class_Of_Products3 Product3_2("Burger", "Fast Food Products", 19000.0, 10);
Class_Of_Products3 Product3_3("Potatoe Fries", "Fast Food Products", 15000.0, 10);


class LegendrySanninsMart {
    private:
        // Password and login for Owner
        string Owner_Login_Sign = "1";
        string Owner_Password_Sign = "1";

    protected:
        // Functions
        void Sign_in();
        void About();
        void Owner_Main_Menu();
        void Owner_Products_Stotage();
        void Modify_Info_Products(int take_product_location);
        void Owner_Customers_List();
        void User_Main_Menu();
        void Table_For_Increasing_And_Decreasing();
        void Class_Of_Products1_Menu();
        void Class_Of_Products2_Menu();
        void Class_Of_Products3_Menu();
        void Cart_Check();

    public:
        void General_Menu();
};


int main()
{
    start(); // calling from header file "menu"

    LegendrySanninsMart Mart;
    Mart.General_Menu();

    return 0;
}

void LegendrySanninsMart :: General_Menu()
{
    for (int i = 0; i < 1000; i++)
    {
        system("cls");
        cout << "__________________________________________________________________________________________________________ \n";
        cout << "  L E G E N D R Y  S A N N I N S  M A R T                                    A U T H E N T I C A T I O N    \n";
        cout << "__________________________________________________________________________________________________________ \n\n";
        cout << "\t\t\t\t\t  Authentication \n"
             << endl;
        cout << "\t\t\t\t\t   1. Sign in" << endl;
        cout << "\t\t\t\t\t   2. Sign up" << endl;
        cout << "\t\t\t\t\t   3. About" << endl;
        cout << "\t\t\t\t\t   0. Exit" << endl
             << endl;
        cout << "\t\t\t\t\t  Your Choice: ";

        switch (getch())
        {
        case 49:
            // Sign in
            system("cls");
            Sign_in();
            system("pause");
            break;

        case 50:
            // Register
            // Set details with validation
            for (int i = 0; i != 1;)
            {
                system("cls");
                cout << "____________________________________________________________________________________________________ \n";
                cout << "  L E G E N D R Y  S A N N I N S  M A R T                                  R E G I S T R A T I O N    \n";
                cout << "____________________________________________________________________________________________________\n\n";
                cout << "\t\t\t\t       Example of Registration: " << endl;
                cout << "\t\t\t\t       ________________________" << endl;
                cout << "\t\t\t\t        User Name : MuhaibShamsher " << endl;
                cout << "\t\t\t\t        Telephone : 03448625508 " << endl;
                cout << "\t\t\t\t        Login     : Muhaib123 " << endl;
                cout << "\t\t\t\t        Password  : Muhaib123 " << endl;
                cout << "\t\t\t\t       ________________________" << endl
                     << endl;

                User_Validtaion.SetUser();
                ValidationPassword(User_Validtaion);
                ValidationName(User_Validtaion);
                ValidationTellNum(User_Validtaion);

                if (validation == 3)
                {
                    // File Handling For User Info
                    ofstream User_Info;
                    User_Info.open("User_Info.txt", ios::app); // Opening File

                    // Setting User Info in Memory
                    User_Info << Name_Memory << endl;
                    User_Info << TellNum_Memory << endl;
                    User_Info << Login_Memory << endl;
                    User_Info << Password_Memory << endl;
                    User_Info.close();
                    // End of the File Handling

                    cout << "\t\t\t\t __________________________________" << endl;
                    cout << "\t\t\t\t      Correct Validation" << endl;
                    i++;
                    cout << "\t\t\t\tPlease press any key to continue..." << endl
                         << endl;
                    system("Pause");
                    validation = 0;
                }

                else
                {
                    cout << "\t\t\t\t __________________________________" << endl;
                    cout << "\t\t\t\t       Invalid Validation" << endl;
                    cout << "\t\t  Please press '1' to rewrite || Press any key to go back to menu" << endl
                         << endl;
                    validation = 0;

                    switch (getch())
                    {
                    case 49:
                        // Rewriting i=0;
                        break;

                    default:
                        General_Menu();
                    }
                }
            }
            break;

        case 51:
            // About
            system("cls");
            About();
            break;

        case 48:
            // Exist
            system("cls");
            cout << "\n\n\t\t\t Thank you for your attention! \n\n\n\n";
            system("pause");
            exit(0);
            break;

        default:
            cout << "\n\n\t\t\t Your choice is not available in Menu." << endl;
            cout << "\t\t\t Please enter correct keys." << endl;
            system("pause");
            break;
        }
    }
}
// DONE

void LegendrySanninsMart :: About()
{
    cout << endl
         << endl;
    cout << "\t\t\t\t*************************************************\n";
    cout << "\t\t\t\t*                                               *\n";
    cout << "\t\t\t\t*   -----------------------------------------   *\n";
    cout << "\t\t\t\t*    L E G E N D R Y  S A N N I N S  M A R T    *\n";
    cout << "\t\t\t\t*   -----------------------------------------   *\n";
    cout << "\t\t\t\t*                                               *\n";
    cout << "\t\t\t\t*             Project By:                       *\n";
    cout << "\t\t\t\t*             MUHAIB SHAMSHER (CR-029)          *\n";
    cout << "\t\t\t\t*             MUNEEZA BADAR   (CR-022)          *\n";
    cout << "\t\t\t\t*             MUHAMMAD HAMZA  (CR-048)          *\n";
    cout << "\t\t\t\t*                                               *\n";
    cout << "\t\t\t\t*                                               *\n";
    cout << "\t\t\t\t*                                               *\n";
    cout << "\t\t\t\t*                     OOP PROJECT 2023          *\n";
    cout << "\t\t\t\t*                     Course Instructor:        *\n";
    cout << "\t\t\t\t*                     SIR SHARIQ MAHMOOD KHAN   *\n";
    cout << "\t\t\t\t*                                               *\n";
    cout << "\t\t\t\t*                                               *\n";
    cout << "\t\t\t\t*************************************************\n\n\n";

    cout << "\n\t\t\t\tPress any key to go back to Menu \n\n";
    system("pause");
}
// DONE

void LegendrySanninsMart :: Sign_in()
{
    for (int i = 0; i < 1000; i++)
    {
        string Login_Sign, Password_Sign;

        system("cls");
        cout << "_______________________________________________________________________________________________________ \n";
        cout << "  L E G E N D R Y  S A N N I N S  M A R T                                                S I G N  I N   \n";
        cout << "_______________________________________________________________________________________________________\n\n";
        cout << "\t\t\t\t\t   Sign in\n\n";
        cout << "\t\t\t\t\t1. Sign in as Owner" << endl;
        cout << "\t\t\t\t\t2. Sign in as User" << endl;
        cout << "\t\t\t\t\t0. Back" << endl
             << endl;
        cout << "\t\t\t\t\t   Your Choice: ";

        switch (getch())
        {
        case 49:
            // Sign in as Owner
            system("cls");
            cout << "______________________________________________________________________________________________________ \n";
            cout << "  L E G E N D R Y  S A N N I N S  M A R T                                                  O W N E R          \n";
            cout << "______________________________________________________________________________________________________\n\n";

            cout << "\t\t\t\t\t Owner Authentication\n\n";
            cout << "\t\t\t\t\t Login    : ";
            cin >> Login_Sign;

            Password_Sign = Function_Password_Val(); // the funcation will take Password as input

            if (Login_Sign == Owner_Login_Sign && Password_Sign == Owner_Password_Sign)
            {
                // Owner's Menu
                Owner_Main_Menu();
                system("pause");
            }

            else
            {
                // If Login hasn't Registered
                cout << endl
                     << endl;
                cout << "\t\t\t   Your Login and Password are Invalid." << endl;
                cout << "\t\t\t   Please press any key to go back to 'Sign in' Menu.\n";
                cout << endl
                     << endl;
                system("pause");
                Sign_in();
            }
            break;

        case 50:
        {
            // Sign in as User
            system("cls");
            cout << "______________________________________________________________________________________________________\n";
            cout << "  L E G E N D R Y  S A N N I N S  M A R T                                            C U S T O M E R  \n";
            cout << "______________________________________________________________________________________________________\n\n";
            cout << "\t\t\t\t      Customer Authentication\n\n";
            cout << "\t\t\t\t\tLogin    : ";
            cin >> Login_Sign;

            Password_Sign = Function_Password_Val();

            // File Handling For User Info
            ifstream Search;
            Search.open("User_Info.txt");

            while (Search)
            {
                Search >> Name_Memory;
                Search >> TellNum_Memory;
                Search >> Login_Memory;
                Search >> Password_Memory;
                if (Login_Sign == Login_Memory && Password_Sign == Password_Memory)
                {
                    User user(Name_Memory, TellNum_Memory, Login_Memory, Password_Memory);
                    User_Main_Menu();
                }
            }
            Search.close();
            // End of the File Handling

            cout << "\n\n\t\t\t        Your Login and Password are Invalid." << endl;
            cout << "\t\t\t   Please press any key to go back to 'Sign in' Menu.\n\n"
                 << endl;
            system("pause");
            Sign_in();
        }
        break;

        case 48:
            // Back
            system("cls");
            i = 1000;
            General_Menu();
            break;

        default:
            cout << "\n\n\t\t\t    Your choice is not available in Menu." << endl;
            cout << "\t\t\t\t    Please enter correct keys.\n"
                 << endl;
            system("pause");
            break;
        }
    }
}


void LegendrySanninsMart :: Owner_Main_Menu()
{
    system("cls");
    cout << endl
         << endl;

    for (int k = 0; k < 1000; k++)
    {
        system("cls");
        cout << "______________________________________________________________________________________________________\n";
        cout << " L E G E N D R Y  S A N N I N S  M A R T                                          O W N E R  M E N U   \n";
        cout << "______________________________________________________________________________________________________\n\n";

        cout << "       Main Menu\n\n";
        cout << "       1. Products in stock \n\n";
        cout << "       2. Customers list \n\n";
        cout << "       0. Back\n\n";
        cout << "       Your choice: ";

        switch (getch())
        {
        case 49:
            Owner_Products_Stotage();
            break;

        case 50:
            Owner_Customers_List();
            system("pause");
            break;

        case 48:
            // Back to Menu
            system("cls");
            k = 1000;
            Sign_in();
            break;

        default:
            cout << "\t\t\t\t    Your choice is not available in Menu." << endl;
            cout << "\t\t\t\t    Please enter correct keys.\n"
                 << endl;
            system("pause");
            break;
        }
    }
}
// DONE


// DONE

void LegendrySanninsMart :: User_Main_Menu()
{
    for (int i = 0; i < 1000; i++)
    {
        system("cls");
        cout << "____________________________________________________________________________________________________ \n";
        cout << "  L E G E N D R Y  S A N N I N S  M A R T                               U S E R  M A I N  M E N U    \n";
        cout << "____________________________________________________________________________________________________\n\n";

        cout << "\t\t Categories\n\n";
        cout << "\t\t 1. Vegetables & Fruits\n";
        cout << "\t\t 2. Water & Beverages\n";
        cout << "\t\t 3. Fast Food Products\n";
        cout << "\t\t 4. Cart and Overall Sums\n";
        cout << "\t\t 0. Go Back\n\n";
        cout << "\t\t Your choice: ";

        switch (_getch())
        {
        case 49:
            Class_Of_Products1_Menu();
            break;

        case 50:
            Class_Of_Products2_Menu();
            break;

        case 51:
            Class_Of_Products3_Menu();
            break;

        case 52:
            Cart_Check();
            break;

        case 48:
            // Back to Menu
            system("cls");
            i = 1000;
            Sign_in();
            break;

        default:
            cout << endl
                 << endl;
            cout << "\t\t\t\t    Your choice is not available in Menu." << endl;
            cout << "\t\t\t\t    Please enter correct keys.\n"
                 << endl;
            system("pause");
            break;
        }
    }
}
// DONE

void LegendrySanninsMart :: Table_For_Increasing_And_Decreasing()
{
    cout << "____________________________________________________________________________________________________\n";
    cout << "     (+)   'Press 1'                        \n";
    cout << "     (-)   'Press 2'                        \n";
    cout << "     (0)   'Back'                           \n";
    cout << "____________________________________________________________________________________________________\n\n";
    cout << "     Add to Cart:  \n";
}
// DONE

void LegendrySanninsMart :: Class_Of_Products1_Menu()
{
    for (int k = 0; k < 1000; k++)
    {
        system("cls");
        cout << "____________________________________________________________________________________________________ \n";
        cout << "  L E G E N D R Y  S A N N I N S  M A R T                                        P R O D U C T  1    \n";
        cout << "____________________________________________________________________________________________________\n\n";

        cout << "    Products List  \t\t    Category \t\t       Price \t\t   In Stock\n";
        Product1_1.Display();
        Product1_2.Display();
        Product1_3.Display();

        cout << " 0. Back\n\n";
        cout << " Your choice: ";

        switch (getch())
        {
            // for Product1_1  
            case 49:
                for (int j = 0; j < 1000; j++) {
                    system("cls");
                    cout << "    Products List  \t\t    Category\t\t       Price\t\t In Stock\n";
                    Product1_1.Display();
                    position1 = 1;

                    Table_For_Increasing_And_Decreasing();

                    switch (getch())
                    {
                    case 49:
                        if (Product1_1.getQuantity() > 0) {
                            user.Product1_1_User++;
                            Product1_1.quantity--;
                            cout << " Quantity of " << Product1_1.getName() << " - " << user.Product1_1_User << endl;
                            cout << " Successfully added \n";
                            Sleep(0700);
                            Sleep(0700);
                        }

                        else {
                            cout << " Product is over / finished. Sorry!\n";
                            Sleep(0700);
                            Sleep(0700);
                        }
                        break;

                    case 50:
                        if (user.Product1_1_User > 0) { 
                            user.Product1_1_User--;
                            Product1_1.quantity++;
                            cout << " Quantity of " << Product1_1.getName() << " - " << user.Product1_1_User << endl;
                            cout << " Successfully decreased \n";
                            Sleep(0700);
                            Sleep(0700);
                        }

                        else {
                            cout << " 0 (kg/pc) can not decrease \n";
                            Sleep(0700);
                            Sleep(0700);
                        }
                        break;

                    case 48:
                        j = 1000;
                        break;
                    }
                }
                break;
            
            // for Product1_2
            case 50:
            {
                for (int j = 0; j < 1000; j++)
                {
                    system("cls");
                    cout << "    Products List  \t\t    Category\t\t       Price\t\t In Stock\n";
                    Product1_2.Display();
                    position1 = 1;

                    Table_For_Increasing_And_Decreasing();

                    switch (getch())
                    {
                    case 49:
                        if (Product1_2.getQuantity() > 0) {
                            user.Product1_2_User++;
                            Product1_2.quantity--;
                            cout << " Quantity of " << Product1_2.getName() << " - " << user.Product1_2_User << endl;
                            cout << "    Successfully added \n";
                            Sleep(0700);
                            Sleep(0700);
                        }

                        else {
                            cout << " Product is over / finished. Sorry!\n";
                            Sleep(0700);
                            Sleep(0700);
                        }
                        break;

                    case 50:
                        if (user.Product1_2_User > 0) { 
                            user.Product1_2_User--;
                            Product1_2.quantity++;
                            cout << " Quantity of " << Product1_2.getName() << " - " << user.Product1_2_User << endl;
                            cout << "    Successfully decreased \n";
                            Sleep(0700);
                            Sleep(0700);
                        }

                        else {
                            cout << " 0 (kg/pc) can not decrease \n";
                            Sleep(0700);
                            Sleep(0700);
                        }
                        break;

                    case 48:
                        j = 1000;
                        break;
                    }
                }   
            }
            break;


            // for Product1_3
            case 51:
            {
                for (int j = 0; j < 1000; j++)
                {
                    system("cls");
                    cout << "    Products List  \t\t    Category\t\t       Price\t\t In Stock\n";
                    Product1_3.Display();
                    position1 = 1;

                    Table_For_Increasing_And_Decreasing();

                    switch (_getch())
                    {
                    case 49:
                        if (Product1_3.getQuantity() > 0) {
                            user.Product1_3_User++;
                            Product1_3.quantity--;
                            cout << " Quantity of " << Product1_3.getName() << " - " << user.Product1_3_User << endl;
                            cout << "    Successfully added \n";
                            Sleep(0700);
                            Sleep(0700);
                        }

                        else {
                            cout << " Product is over / finished. Sorry!\n";
                            Sleep(0700);
                            Sleep(0700);
                        }
                        break;

                    case 50:
                        if (user.Product1_3_User > 0) { 
                            user.Product1_3_User--;
                            Product1_3.quantity++;
                            cout << " Quantity of " << Product1_3.getName() << " - " << user.Product1_3_User << endl;
                            cout << "    Successfully decreased \n";
                            Sleep(0700);
                            Sleep(0700);
                        }

                        else {
                            cout << " 0 (kg/pc) can not decrease \n";
                            Sleep(0700);
                            Sleep(0700);
                        }
                        break;

                    case 48:
                        j = 1000;
                        break;
                    }
                }
            }
            break;

            // Back to User menu
            case 48:
                k = 1000;
                User_Main_Menu();
                break;
                

            default:
                cout << "\n\n\t\t\t\t      Your choice is not available in Menu." << endl;
                cout << "\t\t\t\t    Please enter correct keys.\n\n";
                system("pause");
                break;
        }
    }
}

void LegendrySanninsMart :: Class_Of_Products2_Menu()
{
    for (int k = 0; k < 1000; k++)
    {
        system("cls");
        cout << "____________________________________________________________________________________________________ \n";
        cout << "  L E G E N D R Y  S A N N I N S  M A R T                                        P R O D U C T  2    \n";
        cout << "____________________________________________________________________________________________________\n\n";

        cout << "    Products List  \t\t    Category\t\t       Price\t\t In Stock\n";
        Product2_1.Display();
        Product2_2.Display();
        Product2_3.Display();

        cout << " 0. Back\n\n";
        cout << " Your choice: ";
        switch (_getch())
        {

        // Product2_1
        case 49:
        {
            for (int j = 0; j < 1000; j++)
            {
                system("cls");
                cout << "    Products List  \t\t    Category\t\t       Price\t\t In Stock\n";
                Product2_1.Display();
                position1 = 1;

                Table_For_Increasing_And_Decreasing();
                switch (_getch())
                {
                case 49:
                    if (Product2_1.getQuantity() > 0) {
                        // checking for storage and user needs
                        Product2_1.quantity--;
                        user.Product2_1_User++;
                        cout << " Quantity of " << Product2_1.getName() << " - " << user.Product2_1_User << endl;
                        cout << "    Successfully added \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " Product is over / finished. Sorry!\n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;

                case 50:
                    if (user.Product2_1_User > 0) {
                        // Check for (-1 kg/pc)
                        Product2_1.quantity++;
                        user.Product2_1_User--;
                        cout << " Quantity of " << Product2_1.getName() << " - " <<user.Product2_1_User << endl;
                        cout << "    Successfully decreased \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " 0 (kg/pc) can not decrease \n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;

                case 48:
                    j = 1000;
                    break;
                }
            }
        }
        break;

        // Product2_2
        case 50:
        {
            for (int j = 0; j < 1000; j++)
            {
                system("cls");
                cout << "    Products List  \t\t    Category\t\t       Price\t\t In Stock\n";
                Product2_2.Display();
                position1 = 1;

                Table_For_Increasing_And_Decreasing();
                switch (_getch())
                {
                case 49:
                    if (Product2_2.getQuantity() > 0) {
                        // checking for storage and user needs
                        Product2_2.quantity--;
                        user.Product2_2_User++;
                        cout << " Quantity of " << Product2_2.getName() << " - " << user.Product2_2_User << endl;
                        cout << "    Successfully added \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " Product is over / finished. Sorry!\n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;

                case 50:
                    if (user.Product2_2_User > 0) {
                        // Check for (-1 kg/pc)
                        Product2_2.quantity++;
                        user.Product2_2_User--;
                        cout << " Quantity of " << Product2_2.getName() << " - " << user.Product2_2_User << endl;
                        cout << "    Successfully decreased \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " 0 (kg/pc) can not decrease \n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;

                case 48:
                    j = 1000;
                    break;
                }
            }
        }
        break;

        // Product2_3
        case 51:
        {
            for (int j = 0; j < 1000; j++)
            {
                system("cls");
                cout << "    Products List  \t\t    Category\t\t       Price\t\t In Stock\n";
                Product2_3.Display();
                position1 = 1;

                Table_For_Increasing_And_Decreasing();
                switch (_getch())
                {
                case 49:
                    if (Product2_3.getQuantity() > 0) { 
                        // checking for storage and user needs
                        Product2_3.quantity--;
                        user.Product2_3_User++;
                        cout << " Quantity of " << Product2_3.getName() << " - " << user.Product2_3_User << endl;
                        cout << "    Successfully added \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " Product is over / finished. Sorry!\n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;

                case 50:
                    if (user.Product2_3_User > 0) {
                        // Check for (-1 kg/pc)
                        Product2_3.quantity++;
                        user.Product2_3_User--;
                        cout << " Quantity of " << Product2_3.getName() << " - " << user.Product2_3_User << endl;
                        cout << "    Successfully decreased \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " 0 (kg/pc) can not decrease \n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;

                case 48:
                    j = 1000;
                    break;
                }
            }
        }
        break;
        

        case 48:
        {
            k = 1000;
            User_Main_Menu();
        }
        break;


        default:
            cout << "\n\n\t\t\t       Your choice is not available in Menu." << endl;
            cout << "\t\t\t\t    Please enter correct keys.\n"
                 << endl;
            system("pause");
            break;

        } // switch ends

    } // loop ends

} // function ends

void LegendrySanninsMart :: Class_Of_Products3_Menu()
{
    for (int k = 0; k < 1000; k++)
    {
        
        system("cls");
        cout << "____________________________________________________________________________________________________ \n";
        cout << "  L E G E N D R Y  S A N N I N S  M A R T                                        P R O D U C T  3    \n";
        cout << "____________________________________________________________________________________________________\n\n";

        cout << "    Products List  \t\t    Category\t\t       Price\t\t In Stock\n";
        Product3_1.Display();
        Product3_2.Display();
        Product3_3.Display();

        cout << " 0. Back\n\n";
        cout << " Your choice: ";
        switch (_getch())
        {
        // Product3_1
        case 49:
        { 
            for (int j = 0; j < 1000; j++)
            {
                system("cls");

                cout << "    Products List  \t\t    Category\t\t       Price\t\t In Stock\n";
                Product3_1.Display();
                position1 = 1;

                Table_For_Increasing_And_Decreasing();
                switch (_getch())
                {
                case 49:
                    if (Product3_1.getQuantity() > 0) {
                        Product3_1.quantity--;
                        user.Product3_1_User++;
                        cout << " Quantity of " << Product3_1.getName() << " - " << user.Product3_1_User << endl;
                        cout << "     Successfully added \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " Product is over / finished. Sorry!\n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;

                case 50:
                    if (user.Product3_1_User > 0) {
                        Product3_1.quantity++;
                        user.Product3_1_User--;
                        cout << " Quantity of " << Product3_1.getName() << " - " << user.Product3_1_User << endl;
                        cout << "     Successfully decreased \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " 0 (kg/pc) can not decrease \n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;

                case 48:
                    j = 1000;
                    break;
                }
            }
        }
        break;

        // Product3_2
        case 50:
        {
            for (int j = 0; j < 1000; j++)
            {
                system("cls");
                cout << "    Products List  \t\t    Category\t\t       Price\t\t In Stock\n";
                Product3_2.Display();
                position1 = 1;

                Table_For_Increasing_And_Decreasing();
                switch (_getch())
                {
                case 49:
                    if (Product3_2.getQuantity() > 0) {
                        Product3_2.quantity--;
                        user.Product3_2_User++;
                        cout << " Quantity of " << Product3_2.getName() << " - " << user.Product3_2_User << endl;
                        cout << "     Successfully added \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " Product is over / finished. Sorry!\n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;
                case 50:
                    if (user.Product3_2_User > 0) {
                        Product3_2.quantity++;
                        user.Product3_2_User--;
                        cout << " Quantity of " << Product3_2.getName() << " - " << user.Product3_2_User << endl;
                        cout << "     Successfully decreased \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " 0 (kg/pc) can not decrease \n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;

                case 48:
                    j = 1000;
                    break;
                }
            }
        }
        break;

        // Product3_3
        case 51:
        {
            for (int j = 0; j < 1000; j++)
            {
                system("cls");
                cout << "    Products List  \t\t    Category\t\t       Price\t\t In Stock\n";
                Product3_3.Display();
                position1 = 1;

                Table_For_Increasing_And_Decreasing();
                switch (_getch())
                {
                case 49:
                    if (Product3_3.getQuantity() > 0) {
                        Product3_3.quantity--;
                        user.Product3_3_User++;
                        cout << " Quantity of " << Product3_3.getName() << " - " << user.Product3_3_User << endl;
                        cout << "     Successfully added \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " Product is over / finished. Sorry!\n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;

                case 50:
                    if (user.Product3_3_User > 0) {
                        Product3_3.quantity++;
                        user.Product3_3_User--;
                        cout << " Quantity of " << Product3_3.getName() << " - " << user.Product3_3_User << endl;
                        cout << "     Successfully decreased \n";
                        Sleep(0700);
                        Sleep(0700);
                    }

                    else {
                        cout << " 0 (kg/pc) can not decrease \n";
                        Sleep(0700);
                        Sleep(0700);
                    }
                    break;

                case 48:
                    j = 1000;
                    break;
                }
            }
        }
        break;

        // Back to F_User menu
        case 48:
            k = 1000;
            User_Main_Menu();
            break;
        
        default:
            cout << "\n\n\t\t\t       Your choice is not available in Menu." << endl;
            cout << "\t\t\t\t    Please enter correct keys.\n" << endl;
            system("pause");

        } // switch ends
    } // loop ends
} // function ends

void LegendrySanninsMart :: Cart_Check() {

	system("cls");
    cout << "____________________________________________________________________________________________________ \n";
    cout << "   L E G E N D R Y  S A N N I N S  M A R T                                                C A R T    \n";
    cout << "____________________________________________________________________________________________________\n\n";
	
    // Check
    double Overall_Sum = 0;
	for (int i = 1; i <= 1; i++)
    {
		if (user.Product1_1_User > 0) {
			cout << "\n\t\t\t  " << i << ". " << Product1_1.getName() << " --- " << user.Product1_1_User << " --- Price: " << user.Product1_1_User * Product1_1.getPrice();
			i++;
			Overall_Sum += user.Product1_1_User * Product1_1.getPrice();
		}

		if (user.Product1_2_User > 0) {
			cout << "\n\t\t\t  " << i << ". " << Product1_2.getName() <<" --- " << user.Product1_2_User << " --- Price: " << user.Product1_2_User * Product1_2.getPrice();
			i++;
			Overall_Sum += user.Product1_2_User * Product1_2.getPrice();
		}

		if (user.Product1_3_User > 0) {
			cout << "\n\t\t\t  " << i << ". " << Product1_3.getName() <<" --- " << user.Product1_3_User << " --- Price: " << user.Product1_3_User * Product1_3.getPrice();
			i++;
			Overall_Sum += user.Product1_3_User * Product1_3.getPrice();
		}

		if (user.Product2_1_User > 0) {
			cout << "\n\t\t\t  " << i << ". " << Product2_1.getName() <<" --- " << user.Product2_1_User << " --- Price: " << user.Product2_1_User * Product2_1.getPrice();
			i++;
			Overall_Sum += user.Product2_1_User * Product2_1.getPrice();
		}
		if (user.Product2_2_User > 0) {
			cout << "\n\t\t\t  " << i << ". " << Product2_2.getName() <<" --- " << user.Product2_2_User << " --- Price: " << user.Product2_2_User * Product2_2.getPrice();
			i++;
			Overall_Sum += user.Product2_2_User * Product2_2.getPrice();
		}
		if (user.Product2_3_User > 0) {
			cout << "\n\t\t\t  " << i << ". " << Product2_3.getName() << " --- " << user.Product2_3_User << " --- Price: " << user.Product2_3_User * Product2_3.getPrice();
			i++;
			Overall_Sum += user.Product2_3_User * Product2_3.getPrice();
		}
		if (user.Product3_1_User > 0) {
			cout << "\n\t\t\t  " << i << ". " << Product3_1.getName() << " --- " << user.Product3_1_User << " --- Price: " << user.Product3_1_User * Product3_1.getPrice();
			i++;
			Overall_Sum += user.Product3_1_User * Product3_1.getPrice();
		}
		if (user.Product3_2_User > 0) {
			cout << "\n\t\t\t  " << i << ". " << Product3_2.getName() << " --- " << user.Product3_2_User << " --- Price: " << user.Product3_2_User * Product3_2.getPrice();
			i++;
			Overall_Sum += user.Product3_2_User * Product3_2.getPrice();
		}
		if (user.Product3_3_User > 0) {
			cout << "\n\t\t\t  " << i << ". " << Product3_3.getName()<< " --- " << user.Product3_3_User << " --- Price: " << user.Product3_3_User * Product3_3.getPrice();
			i++;
			Overall_Sum += user.Product3_3_User * Product3_3.getPrice();
		}

		if (i == 1) { 
            // if nothing go to Menu
			cout << "\n\t You do not have any product in 'CART'.\n";
			cout << "\tPress any key to go to 'Products Menu'\n\n" << endl;
			system("pause");
			Overall_Sum = 0;
			User_Main_Menu();
		}
		if (i > 1) { 
            // Menu for buying or back 
			cout << "\n\n\t\t\t  Overall Price: " << Overall_Sum << " Sums" << endl;
			cout << "\n\t   1. Buy now" << endl;
			cout << "\t   0. Products Menu" << endl;

			switch (_getch()) {
			case 49: { //buy
				system("cls");
				////
				cout << "____________________________________________________________________________________________________ \n";
				cout << "                                              C A R T \n";
				cout << "____________________________________________________________________________________________________\n\n";

				cout << " Money will be taken from your 'Telephone Number': " << endl;
				cout << " 1. OK" << endl;
				cout << " Press any key to go back..." << endl;
				switch (_getch())
                {
                    case 49:
                    {
                        cout << "\n\t  Transaction Successful!\n\t  Congratulations ! :)" << endl;
                        system("pause");
                        Overall_Sum = 0;
                        // Storage
                        user.Product1_1_User = 0; user.Product1_3_User = 0; user.Product1_2_User = 0;
                        user.Product2_1_User = 0; user.Product2_2_User = 0; user.Product2_3_User = 0;
                        user.Product3_1_User = 0; user.Product3_2_User = 0; user.Product3_3_User = 0;
                        User_Main_Menu();
                    }
                    break;

                    default:  
                        Cart_Check();
				}
				system("pause");
			}
			break;

			case 48:
            { // Back
				system("cls");
				Overall_Sum = 0;
				User_Main_Menu();
			}
			break;

			default: 
                Cart_Check();

			} // switch ends
		} //if ends
	}// loop end
} // 
