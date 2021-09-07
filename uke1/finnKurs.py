def read_csv(filnavn):
    tuppel = set()
    f = open(filnavn, "r")

    for linje in f:
        tuppel.add(linje.strip("\n"))

    return tuppel


set = read_csv("uke1/tar_kurs.csv")
tuppel = tuple(set)
print(tuppel)


# Pseudokode:
# students := csv_read("studenter.csv")
# kurs := csv_read("kurs.csv")
# tar_kurs := csv.read("tar_kurs.csv")
#
# sortere_kurs = new Sorted_list()
#
# for s in students:
#   if ("1992-01-01 < s[4]"):
#       for tk in tar_kurs:
#           if (s[0] == t[0] and t[1] startsWith("IN")):
#               for k in kurs:
#                   if (t[1] == k[0] and not sortere_kurs.contains(k)):
#                       sortere_kurs.add(k)
#                   end if
#               end for
#           end if
#       end for
#   end if
# end for
#
#for k in sortere_kurs:
#   print()
#end for
