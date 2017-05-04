# -*- coding:  utf-8 -*-

color = {
   'base03': (0.000, 0.169, 0.212),
   'base02': (0.027, 0.212, 0.259),
   'base01': (0.345, 0.431, 0.459),
   'base00': (0.396, 0.482, 0.514),
   'base0': (0.514, 0.580, 0.588),
   'base1': (0.576, 0.631, 0.631),
   'base2': (0.933, 0.910, 0.835),
   'base3': (0.992, 0.965, 0.890),
   'yellow': (0.710, 0.537, 0.000),
   'orange': (0.796, 0.294, 0.086),
   'red': (0.863, 0.196, 0.184),
   'magenta': (0.827, 0.212, 0.510),
   'violet': (0.424, 0.443, 0.769),
   'blue': (0.149, 0.545, 0.824),
   'cyan': (0.165, 0.631, 0.596),
   'green': (0.522, 0.600, 0.000)
}


def get_color(name):
   c = color[name]
   return '#{: 02x}{: 02x}{: 02x}'.format(int(c[0] * 255), int(c[1] * 255), int(c[2] * 255))