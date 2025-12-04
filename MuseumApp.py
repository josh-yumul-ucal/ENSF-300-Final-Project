import mysql.connector

def guest_view():
    item_view = int(input("What would you like to browse?" \
    "\n1 for Art Pieces" \
    "\n2 for Exhibitions" \
    "\n3 for Artists" \
    "\n0 to exit "
    ))
    if (item_view == 1):
        view_art_pieces()
    elif (item_view == 2):
        view_exhibitions()
    elif (item_view == 3):
        view_artists()
    elif (item_view == 0):
        return
    else:
        print("Invalid input, please try again")
        guest_view()

def view_art_pieces():
    art_type = int(input("What type of art would you like to browse?" \
    "\n1 for Paintings" \
    "\n2 for Sculptures" \
    "\n3 for Statues" \
    "\n4 for Other" \
    "\n0 for Back "                     
    ))
    if (art_type == 1):
        browse_paintings()
    elif (art_type == 2):
        browse_sculptures()
    elif (art_type == 3):
        browse_statues()
    elif (art_type == 4):
        browse_other()
    elif (art_type == 0):
        guest_view()
    else:
        print("Invalid selection, please try again.")

def view_exhibitions():
    while True:
        cur.execute("SELECT ExName FROM EXHIBITIONS ORDER BY ExName;")
        exhibitions = [row[0] for row in cur.fetchall()]

        print("\nWhich exhibition would you like to look at?")
        for i, name in enumerate(exhibitions, start=1):
            print(f"{i}: {name}")
        print("0: Back")

        try:
            choice = int(input("\nEnter a number: "))
        except ValueError:
            print("Invalid input. Please enter a number.\n")
            continue

        if choice == 0:
            return guest_view()
        elif 1 <= choice <= len(exhibitions):
            ex_name = exhibitions[choice - 1]
            display_exhibitions(ex_name)
        else:
            print("Invalid selection, please try again.\n")

def view_artists():
    while True:
        cur.execute("SELECT Name FROM ARTIST ORDER BY Name;")
        artists = [row[0] for row in cur.fetchall()]

        print("\nWhich artist's information would you like to look at?")
        for i, name in enumerate(artists, start=1):
            print(f"{i}: {name}")
        print("0: Back")

        try:
            choice = int(input("\nEnter a number: "))
        except ValueError:
            print("Invalid input, please enter a number.\n")
            continue

        if choice == 0:
            return guest_view()
        elif 1 <= choice <= len(artists):
            artist_name = artists[choice - 1]
            display_artists(artist_name)
        else:
            print("Invalid selection, please try again.\n")

def display_exhibitions(ex_name):
    query = (
    "SELECT ExName AS ExhibitionName, StartDate, EndDate "
    "FROM EXHIBITIONS "
    "WHERE ExName = '" + ex_name + "';"
    )
    print(query)
    cur.execute(query)
    print("\nExhibitions: ")
    print_query_results(cur)

def display_artists(artist_name):
    query = (
        "SELECT "
        "A.Name, A.Style, A.BirthDate, A.DeathDate, A.Origin, A.Epoch, A.Description, "
        "AO.ArtID, AO.Title "
        "FROM ARTIST A "
        "JOIN CREATEDBY CB ON A.Name = CB.ArtistName "
        "JOIN ARTOBJECTS AO ON CB.ArtID = AO.ArtID "
        "WHERE A.Name = '" + artist_name + "';"
    )
    cur.execute(query)
    print("\nSelected artist's information:")
    print_query_results(cur)


def browse_paintings():
    query = """ 
        SELECT 
            AO.ArtID,
            AO.Title,
            A.Name AS ArtistName,
            AO.Year,
            AO.Epoch,
            P.PaintType,
            P.Material,
            P.Style,
            OD.ExName AS ExhibitionName
        FROM ARTOBJECTS AO
        LEFT JOIN CREATEDBY CB ON AO.ArtID = CB.ArtID
        LEFT JOIN ARTIST A ON CB.ArtistName = A.Name
        LEFT JOIN PAINTING P ON AO.ArtID = P.ID
        LEFT JOIN ONDISPLAY OD ON AO.ArtID = OD.ArtID;"""
    cur.execute(query)
    print("\nPaintings:")
    print_query_results(cur)
    guest_view()

def browse_sculptures():
    query = """
        SELECT 
            AO.ArtID,
            AO.Title,
            A.Name AS ArtistName,
            AO.Year,
            AO.Epoch,
            S.Height,
            S.Material,
            S.Style,
            S.Weight,
            OD.ExName AS ExhibitionName
        FROM ARTOBJECTS AO
        LEFT JOIN CREATEDBY CB ON AO.ArtID = CB.ArtID
        LEFT JOIN ARTIST A ON CB.ArtistName = A.Name
        LEFT JOIN SCULPTURE S ON AO.ArtID = S.ID
        LEFT JOIN ONDISPLAY OD ON AO.ArtID = OD.ArtID;"""
    cur.execute(query)
    print("\nSculptures:")
    print_query_results(cur)
    guest_view()

def browse_statues():
    query = """
        SELECT 
            AO.ArtID,
            AO.Title,
            A.Name AS ArtistName,
            AO.Year,
            AO.Epoch,
            St.Height,
            St.Material,
            St.Style,
            St.Weight,
            OD.ExName AS ExhibitionName
        FROM ARTOBJECTS AO
        LEFT JOIN CREATEDBY CB ON AO.ArtID = CB.ArtID
        LEFT JOIN ARTIST A ON CB.ArtistName = A.Name
        LEFT JOIN STATUE St ON AO.ArtID = St.ID
        LEFT JOIN ONDISPLAY OD ON AO.ArtID = OD.ArtID;"""
    cur.execute(query)
    print("\nStatues:")
    print_query_results(cur)
    guest_view()

def browse_other():
    query = """
        SELECT 
            AO.ArtID,
            AO.Title,
            A.Name AS ArtistName,
            AO.Year,
            AO.Epoch,
            O.Type,
            O.Style,
            OD.ExName AS ExhibitionName
        FROM ARTOBJECTS AO
        LEFT JOIN CREATEDBY CB ON AO.ArtID = CB.ArtID
        LEFT JOIN ARTIST A ON CB.ArtistName = A.Name
        LEFT JOIN OTHERART O ON AO.ArtID = O.ArtID
        LEFT JOIN ONDISPLAY OD ON AO.ArtID = OD.ArtID;"""
    cur.execute(query)
    print("\nOther Art:")
    print_query_results(cur)
    guest_view()


def print_query_results(cur):
    rows = cur.fetchall()
    col_names = cur.column_names

    if not rows:
        print("\nNo results.\n")
        return
    
    print()
    for name in col_names:
        print("{:<20s}".format(str(name)), end='')
    print()
    print("-" * (20 * len(col_names)))

    for row in rows:
        for val in row:
            print("{:<20s}".format(str(val)), end='')
        print()
    print()

def data_entry():
    query_type = int(input("Select your query type:" \
    "\n1: Insert" \
    "\n2: Update" \
    "\n3: Delete" \
    "\n4: Select" \
    "\n5: Search\n"))
    discern_query(query_type)

def discern_query(query_type):
    if (query_type == 1):
        allowed_query = "INSERT"
    elif (query_type == 2):
        allowed_query = "UPDATE"
    elif (query_type == 3):
        allowed_query = "DELETE"
    elif (query_type == 4):
        allowed_query = "SELECT" 
    elif (query_type == 5):
        user_search_input = input("Search: ")
        user_search(user_search_input)
        data_entry()
    else:
        print("Invalid input, please try again")
        return data_entry()
    perform_query(allowed_query)

def user_search(user_search_input):
    term = "%" + user_search_input.strip() + "%"
    print(f'\nSearching for: "{user_search_input}"\n')

    print("🔎 Artists matching your search:\n")
    query_artists = """
        SELECT Name, Style, Origin, Epoch, BirthDate, DeathDate
        FROM ARTIST
        WHERE Name LIKE %s
           OR Style LIKE %s
           OR Origin LIKE %s
           OR Epoch LIKE %s
           OR Description LIKE %s;
    """
    cur.execute(query_artists, (term, term, term, term, term))
    print_query_results(cur)

    print("\n🔎 Artworks matching your search:\n")
    query_artworks = """
        SELECT AO.ArtID, AO.Title, AO.Year, AO.Epoch, AO.Country,
               GROUP_CONCAT(A.Name SEPARATOR ', ') AS Artists
        FROM ARTOBJECTS AO
        LEFT JOIN CREATEDBY C ON AO.ArtID = C.ArtID
        LEFT JOIN ARTIST A ON C.ArtistName = A.Name
        WHERE AO.Title LIKE %s
           OR AO.Description LIKE %s
           OR AO.Country LIKE %s
           OR AO.Epoch LIKE %s
           OR A.Name LIKE %s
        GROUP BY AO.ArtID, AO.Title, AO.Year, AO.Epoch, AO.Country;
    """
    cur.execute(query_artworks, (term, term, term, term, term))
    print_query_results(cur)

    print("\n🔎 Exhibitions matching your search:\n")
    query_exhibitions = """
        SELECT ExName, StartDate, EndDate
        FROM EXHIBITIONS
        WHERE ExName LIKE %s;
    """
    cur.execute(query_exhibitions, (term,))
    print_query_results(cur)

    print("\nSearch complete.\n")


def perform_query(allowed_query):
    while True:
        print("(Ensure Directory Path is correct with no \"quotation marks\")")
        print("To cancel, insert \"LEAVE\"")
        file_path = input("Insert file path: ")
        if (file_path == "LEAVE"):
            print("Cancelling query")
            break
        try:
            with open(file_path, 'r') as f:
                sql_query = f.read().strip()
            break 
        except FileNotFoundError:
            print("Error: File not found. Please try again.\n")
        except IOError:
            print("Error: Unable to read the file (permission issue or corrupted file). Please try again.\n")


    query_upper = sql_query.upper()

    if not query_upper.startswith(allowed_query):
        raise ValueError(f"Invalid SQL type. Only {allowed_query} queries are allowed.")

    forbidden_queries = ["INSERT", "UPDATE", "DELETE", "DROP", "ALTER", "TRUNCATE"]
    for word in forbidden_queries:
        if word != allowed_query and word in query_upper:
            raise ValueError(f"Forbidden SQL keyword detected: {word}")

    cur.execute(sql_query)

    if allowed_query == "SELECT":
        return print_query_results(cur)
    else:
        cnx.commit()
        print("Query executed successfully.")
        return None

def data_entry_view():
    print("Enter 1 if you are a data entry user \nEnter 0 if you are a guest viewer")
    user_type_input = int(input())
    if (user_type_input == 1):
        is_data_person = True
    elif (user_type_input == 0):
        is_data_person = False
    else:
        print("Invalid input, please try again")
        return data_entry_view()
    
    return is_data_person

if __name__ == "__main__":
    
    print("Welcome to the Group 10 Art Museum")
    is_data_entering = data_entry_view()
    if (is_data_entering == True):
        username = input("Input Username: ") 
        """dataman"""
        passcode = input("Input password: ")
        """dataman"""
    else:
        username = "Guest"
        passcode= "default"
    
    cnx = mysql.connector.connect(
        host = "localhost",
        port = 3306,
        user = username,
        password = passcode
    )

    cur = cnx.cursor()
    cur.execute("use Museum")

    if (is_data_entering == True):
        data_entry()
    elif (is_data_entering == False):
        guest_view()
