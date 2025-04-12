#!/usr/bin/env python3

# The 1993 video game `Doom` by Id Software used hard-coded random numbers
# that were generated using this algorithm. John Carmack was an amazing
# programmer, maybe the second smartest after Terry A. Davis

display = list()
state = 1
for _ in range(256):
    #print(state >> 16)
    display.append(str(179 + ((state >> 16) % 39)))
    state = (134775813 * state + 1) % (1 << 24)

print(', '.join(display))