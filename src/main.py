def torreHanoi(n, origem, auxiliar, destino):
    if n == 1:
        print(f"Mova o disco 1 da torre {origem} para torre {destino}.")
        return
    torreHanoi(n-1, origem, destino, auxiliar)
    print(f"Mova o disco {n} da torre {origem} para a torre {destino}.")
    torreHanoi(n-1, auxiliar, origem, destino)


num_discos = 3
torreHanoi(num_discos, "A", "B", "C")
