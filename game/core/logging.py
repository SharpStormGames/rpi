from colorama import Fore, Style
from datetime import datetime


def log(type, module, msg):
    current_time = datetime.now().strftime("%H:%M:%S")

    if type.lower() == "log":
        type_color = Fore.GREEN
    elif type.lower() == "err":
        type_color = Fore.RED
    else:
        type_color = Fore.WHITE

    print(
        f"{type_color}[{type} - {current_time}]{Style.RESET_ALL} "
        f"{Fore.BLUE}[{module}]{Style.RESET_ALL} "
        f"{Fore.WHITE}{msg}{Style.RESET_ALL}"
    )
