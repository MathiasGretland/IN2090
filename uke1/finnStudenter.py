def read_csv(filnavn):
    tuppel = set()
    f = open(filnavn, "r")

    for linje in f:
        tuppel.add(linje.strip("\n"))

    return tuppel


set = read_csv("uke1/studenter.csv")
print(set)
tuppel = tuple(set)
print(tuppel[1])
substring = "g"
for t in tuppel:
    att = t.split(",")
    etternavn = att[2]
    forstebokstav = etternavn[1]
    if substring in forstebokstav:
        print("Etternavn som starter på g: " + etternavn)


# Hvordan man utgjør samme funksjon i SQL vil være noe lingende:
# SELECT etternavn
# FROM studenter
# WHERE etternavn LIKE 'g%';

# Pseudokode:
# students := csv_read("studenter.csv")
# for s in students:
#   if s[3].startsWith("g"):
#       print(s[2] + " " + s[3])
#   end if
# end for
