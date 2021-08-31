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
