from decoder import decode
from tkinter import *
from PIL import Image, ImageTk

# 3163 3599
# Ventana principal
root = Tk()
root.withdraw()

# Ventana del menu principal
window = Toplevel()
window.title("Decodificador de imagen")
input_d = StringVar(window)
input_n = StringVar(window)
window.geometry('360x180')


def image_visualizer_windows(num_d, num_n):
    # Decodifica la imagen
    decode(num_d, num_n)
    # Quita la ventana anterior
    window.withdraw()
    # Cambia la ventana
    visual_window = Toplevel()
    visual_window.title("Decodificador de imagen")
    visual_window.geometry('880x360')

    labelOwo = Label(visual_window, text="Imagen codificada", font = "Helvetica 24 bold italic")
    labelOwo.place(x=75, y=0)
    img1 = Image.open("owo.png")
    renderOwo = ImageTk.PhotoImage(img1.resize((320, 214), Image.ANTIALIAS))
    imgOwo = Label(visual_window, image=renderOwo)
    imgOwo.image = renderOwo
    imgOwo.place(x=60, y=80)

    labelUwu = Label(visual_window, text="Imagen decodificada", font="Helvetica 24 bold italic")
    labelUwu.place(x=500, y=0)
    img2 = Image.open("uwu.png")
    renderUwu = ImageTk.PhotoImage(img2.resize((160, 214), Image.ANTIALIAS))
    imgUwu = Label(visual_window, image=renderUwu)
    imgUwu.image = renderUwu
    imgUwu.place(x=580, y=80)

    visual_window.mainloop()


labelTitle = Label(window, text="Decodificador RSA", font = "Helvetica 24 bold italic")
labelTitle.grid(column=0, row=0, columnspan=20, pady=10, padx=30)

labelD = Label(window, text="Valor de d: ")
labelD.grid(column=0, row=1)
entryD = Entry(window, width=30, textvariable=input_d)
entryD.grid(column=1, row=1, columnspan=18)

labelN = Label(window, text="Valor de n: ")
labelN.grid(column=0, row=2)
entryN = Entry(window, width=30, textvariable=input_n)
entryN.grid(column=1, row=2, columnspan=18)

startBtn = Button(window,
                  text="Decodificar",
                  bg='#CAF5E8',
                  command=lambda: image_visualizer_windows(input_d.get(),
                                         input_n.get()))
startBtn.grid(column=19, row=1, sticky=E)

window.mainloop()
