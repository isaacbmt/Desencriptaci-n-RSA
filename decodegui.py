from decoder import decode
from tkinter import *
from PIL import Image, ImageTk

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
    # Quita la ventana anterior
    window.withdraw()
    # Decodifica la imagen
    decode(num_d, num_n)
    # Cambia la ventana
    visual_window = Toplevel()
    visual_window.geometry('720x1920')

    labelOwo = Label(visual_window, text="Imagen codificada", font = "Helvetica 24 bold italic")
    labelOwo.place(x=130, y=0)
    renderOwo = ImageTk.PhotoImage(Image.open("owo.jpg"))
    imgOwo = Label(visual_window, image=renderOwo)
    imgOwo.image = renderOwo
    imgOwo.place(x=120, y=80)

    labelUwu = Label(visual_window, text="Imagen decodificada", font="Helvetica 24 bold italic")
    labelUwu.place(x=1330, y=0)
    renderUwu = ImageTk.PhotoImage(Image.open("uwu.jpg"))
    imgUwu = Label(visual_window, image=renderUwu)
    imgUwu.image = renderUwu
    imgUwu.place(x=1320, y=80)
    
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
                  command=lambda: decode(input_d.get(),
                                         input_n.get()))
startBtn.grid(column=19, row=1, sticky=E)

window.mainloop()
