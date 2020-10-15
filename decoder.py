import cv2
import numpy
import os


def get_bytes_from_file(filename):
    with open(filename, "r") as f:
        return f.read()


def create_image(finname, foutname, width, height):
    # Acomoda el array de la imagen
    data = get_bytes_from_file(finname).rstrip('\x00').rstrip()
    data = data.split(' ')
    data = list(map(int, data))
    data = numpy.array(data)
    # Escribe la imagen
    uwuImage = data.reshape(width, height)
    cv2.imwrite(foutname, uwuImage)


def fix_encode_file(filename):
    with open(filename, "r") as file:
        file = file.read().rstrip(' ').rstrip('\n').rstrip('\x00')
        # Re-escribe el archivo codificado
        wfile = open(filename, "w")
        wfile.write(file + " ")
        wfile.close()


def decode(num_d, num_n):
    # Quita los caracteres no deseaados en el archivo
    fix_encode_file("0.txt")
    # Compila el desencriptador
    os.system("nasm -fwin32 desencriptador.asm")
    os.system("gcc desencriptador.asm -o desencriptar")
    input = "desencriptar " + num_d + " " + num_n
    os.system(input)
    # Crea las imagenes
    create_image("0.txt", "owo.png", 960, 640)
    create_image("isaac3000.txt", "uwu.png", 480, 640)

