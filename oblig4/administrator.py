import psycopg2

# MERK: Må kjøres med Python 3!

# Login details for database user
dbname = "mathige" #Set in your UiO-username
user = "mathige_priv" # Set in your priv-user (UiO-username + _priv)
pwd = "aib0rooCh0" # Set inn the password for the _priv-user you got in a mail

# Gather all connection info into one string
connection = \
    "host='dbpg-ifi-kurs01.uio.no' " + \
    "dbname='" + dbname + "' " + \
    "user='" + user + "' " + \
    "port='5432' " + \
    "password='" + pwd + "'"

def administrator():
    conn = psycopg2.connect(connection)

    ch = 0
    while (ch != 3):
        print("-- ADMINISTRATOR --")
        print("Please choose an option:\n 1. Create bills\n 2. Insert new product\n 3. Exit")
        ch = get_int_from_user("Option: ", True)

        if (ch == 1):
            make_bills(conn)
        elif (ch == 2):
            insert_product(conn)

def make_bills(conn):
    # Oppg 2
    
    print("\n-- BILLS --")
    
    cur = conn.cursor()

    cur.execute("SELECT u.name, u.address, sum(p.price) FROM (SELECT * FROM ws.orders WHERE payed = 0) AS ubetalt JOIN ws.users AS u USING (uid) JOIN ws.products AS p USING (pid) GROUP BY u.name, u.address")

    rows = cur.fetchall()
    for row in rows:
        print()
        print("--Bill--")
        strenge = "Name: " + str(row[0]) + "\n"
        strenge += "Address: " + str(row[1]) + "\n"
        strenge += "Total due: " + str(row[2]) + "\n"
        print(strenge)

def insert_product(conn):
    # Oppg 3
    
    print("\n-- INSERT NEW PRODUCT --")
    product = input("Product name: ")
    price = input("Price: ")
    category = input("Category: ")
    description = input("Description: ")

    cur = conn.cursor()

    cur.execute("INSERT INTO ws.products(name, price, cid, description) VALUES (%s, %s, (SELECT cid FROM ws.categories WHERE name = %s), %s);", (product, price, category, description))
    conn.commit()
    print("New product " + product + " inserted.")
    

def get_int_from_user(msg, needed):
    # Utility method that gets an int from the user with the first argument as message
    # Second argument is boolean, and if false allows user to not give input, and will then
    # return None
    while True:
        numStr = input(msg)
        if (numStr == "" and not needed):
            return None;
        try:
            return int(numStr)
        except:
            print("Please provide an integer or leave blank.");


if __name__ == "__main__":
    administrator()
