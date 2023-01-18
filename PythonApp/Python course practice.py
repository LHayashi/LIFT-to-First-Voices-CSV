# number = 0
#
# while number < 10:
#     number += 2
#     print(number)
# print("Blah")

count = 0

for number in range(1, 10):
    if number % 2 == 0:
        count += 1
        print(number)
print(f"There are {count} even numbers")