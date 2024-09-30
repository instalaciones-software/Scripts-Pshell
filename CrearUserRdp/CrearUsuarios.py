import os
import random
import subprocess
import shutil

create_user_banner = """

  ____                _                 _   _
 / ___|_ __ ___  __ _| |_ ___          | | | |___  ___ _ __
| |   | '__/ _ \/ _` | __/ _ \  _____  | | | / __|/ _ \ '__|
| |___| | |  __/ (_| | ||  __/ |_____| | |_| \__ \  __/ |
 \____|_|  \___|\__,_|\__\___|          \___/|___/\___|_|

                                                
"""

print(create_user_banner)


def crear_carpeta_archivos(nombre_carpeta):

    # Crear la carpeta principal de la aplicacion
    ruta_carpeta_principal = os.path.join("E:/apps/", nombre_carpeta)
    os.mkdir(ruta_carpeta_principal)

    # Crear la subcarpeta 'Configuracion' dentro de la carpeta principal 'geminus'
    ruta_subcarpeta = os.path.join(ruta_carpeta_principal, 'Configuracion')
    os.mkdir(ruta_subcarpeta)

    # ruta donde se encuentra la aplicacion GeminusBM (si la ruta se enncuentra diferente a esta unidad C cambiarla manual)
    RutaAplicacion = "E:/Apps/geminus/"
    RutaConfig = "E:/Apps/geminus/Configuracion/"
    RutaDestino = "E:/apps/" + nombre_carpeta

    # si la carpeta geminus existe en la unidad C: el me copia los archivos de configuracion
    shutil.copy(RutaConfig + "ConfigMnu.dhs", ruta_subcarpeta)
    shutil.copy(RutaConfig + "geminus.ini", ruta_subcarpeta)
    shutil.copy(RutaConfig + "GeminusSilver.cjstyles", ruta_subcarpeta)
    shutil.copy(RutaConfig + "Office2010.dll", ruta_subcarpeta)
    shutil.copy(RutaAplicacion + "GeminusME.exe", RutaDestino)

    # si la carpeta de geminus se encuentra ubicada en la unidad que coloco el usuario debe imprimir esto en pantalla
    print("Los archivos de configuración se copiaron correctamente en " + nombre_carpeta)


def crear_usuario(nombre_usuario, nombre_completo):
    # Generar contraseña aleatoria para los usuarios
    caracteres = "123456879" + "AbCdEfGr" 
    password = ''.join(random.choices(caracteres, k=12))

    # Nombre para crear el usuario y establecer la contraseña
    os.system(
        f"net user {nombre_usuario} {password} /add /fullname:\"{nombre_completo}\"")
    # Asignar permisos
    asignar_permisos(nombre_usuario)

    return password  # Devolver la contraseña generada


def asignar_permisos(nombre_usuario):
    # Asignar por defecto estos grupos (administrador, usuario y escritorio remoto)
    os.system(f"net localgroup Administrators {nombre_usuario} /add")
    os.system(
        f"net localgroup \"Remote Desktop Users\" {nombre_usuario} /add")


def main():
    opcion = input(
        # si presionas la tecla 'y' esta opciones es más que todo para empresas nuevas. 
        "¿Es una empresa nueva? (Y/N) Si Tecleas enter es un N:  ").lower()

    if opcion == "y":
        nombre_carpeta = input(
            "Ingrese el nombre de la carpeta que desea crear, esta carpeta es la ruta de recursos de la empresa : ")
        crear_carpeta_archivos(nombre_carpeta)

    cantidad_usuarios = int(
        input("Ingrese la cantidad de usuarios que desea crear, solo Numeros: "))

    contraseñas = []  # Lista para almacenar contraseñas

    for i in range(1, cantidad_usuarios + 1):
        nombre_usuario = f"{nombre_carpeta}-{i:02}"
        nombre_completo = f"Usuario {nombre_carpeta} {i:02}"

        # Crear usuario y obtener la contraseña generada
        password = crear_usuario(nombre_usuario, nombre_completo)
        contraseñas.append((nombre_usuario, password))

    # Crear archivo de texto con contraseñas
    with open("claves_{}.txt".format(nombre_carpeta), "a") as f:
        for nombre_usuario, password in contraseñas:
            f.write(f"Usuario: {nombre_usuario}, Contraseña: {password}\n")

    

    print("Usuarios creados, Contraseñas almacenadas en claves_" + nombre_carpeta +".txt.")
    
     


    # Llamar al archivo batch después de que main() haya terminado
    ruta_bat = r"E:\Apps\Geminus\Inst\permisos.bat"
    subprocess.call(['cmd', '/c', ruta_bat])
      

if __name__ == "__main__":
    main()
