if you use arch by the way you can download this package from AUR ( yay -S tuxsay )

compilation from source code:

step 1:
you need installed gcc and git package ( Gnu Complier Collection )

$ sudo apt install gcc git - debian-based

$ sudo pacman -S gcc git - arch-based

step 2:
download the project repository

$ git clone https://github.com/Nick-cpp/tuxsay

step 3:
compilation & installation


$ cd tuxsay/

$ g++ -std=c++17 "tuxsay.cpp" -o tuxsay

$ sudo install -Dm755 tuxsay "$pkgdir/usr/bin/tuxsay"

step 4:
program launch

$ tuxsay
