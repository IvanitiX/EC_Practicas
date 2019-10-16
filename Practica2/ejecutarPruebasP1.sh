#!/bin/bash

echo "5.1 - Suma de enteros SS, 32 bits, Acarreo en registro \n"
source ejecutarPruebasSumaAcarreo.sh
echo "5.2 - Suma de enteros SS, 32 bits, Extensión de ceros \n"
source ejecutarPruebasSumaExtCero.sh
echo "5.3 - Suma de enteros CS, 32 bits, Extensión de signo \n"
source ejecutarPruebasSumaExtSigno.sh
echo "5.4 - Media, 32 bits \n"
source ejecutarPruebasMedia32.sh
echo "5.5 - Media, 64 bits\n"
source ejecutarPruebasMedia64.sh