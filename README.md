# Những dotfiles cho Linux

## install.txt

Đây là file với mục đích chứa toàn bộ những gì mà mình cần cài đặt khi vừa set-up một máy Arch Linux mới. Đó là mục tiêu hướng đến còn hiện tại chỉ đang chứa những thứ linh tinh mà thôi.

Mong muốn trong tương lai sẽ là tiến hóa file này thành một shell script tự động hóa việc cài đặt set-up hệ thống.

## Zsh

Về `zsh`, để tiện cho việc di chuyển qua lại giữa nhiều hệ thống khác nhau mà không cần quan tâm quá nhiều về việc tìm kiếm và cài đặt quá nhiều plugin, file `zshrc` được xây dựng dựa trên phần lớn file `zshrc` của Manjaro được chỉnh sửa lại đôi chút. Với việc sử dụng file `zshrc` này, một người chỉ cần dùng vanilla zsh kèm thêm 4 plugin: `zsh-autosuggestions zsh-autocompletions zsh-history-substring-search zsh-syntax-highlighting`.

Vì hệ thống hiện hành trên máy của mình là Arch Linux nên việc cài đặt các plugin cần thiết chỉ đơn giản bằng một câu lệnh duy nhất:

```sh
$ sudo pacman -S $(cat install.txt)
```

Các distribution khác thì không đảm bảo toàn bộ plugin có trong official repo nên có thể sẽ không thể cài đặt tương tự như Arch Linux hay những Arch-based distributions. Vì vậy, những bạn tham khảo có thể sẽ phải cài đặt các plugin khác với cách cài đặt bên trên.

Ngoài ra, mình cũng tinh chỉnh lại zsh của mình cho giống với bash, từ PROMPT cho đến key-binding (hoàn toàn dựa vào `zshrc` mặc định của Manjaro cung cấp). Mục đích là do mình thích PS1 mặc định của bash và lỡ người khác có dùng máy mình thì không thấy lạ lẫm thôi chứ không có gì cả :penguin:

## Vim

Đầu tiên, mình không phải là một người dùng Vim toàn thời gian, mình là người dùng Sublime và VSCode song song với VIm trong một số tác vụ nhất định. Tuy nhiên, để làm mình vui vẻ và cho màn hình Vim của mình đẹp đẽ hơn, mình cũng custom Vim đến một mức nhất định mà thôi, chủ yếu là một số plugin nhỏ nhẹ và cài đặt thêm theme.

Các plugin / theme có sẵn trong `vimrc` bao gồm:

1. [`edge` theme](https://github.com/sainnhe/edge)
2. [`synthwave84` theme](https://github.com/artanikin/vim-synthwave84)
3. [`vim-airline` plugin](https://github.com/vim-airline/vim-airline)

Các plugin và theme trên được quản lý bởi [vim-plug](https://github.com/junegunn/vim-plug). Để cài đặt vim-plug, chúng ta cần phải chạy lệnh sau:

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Sau khi đã có vim-plug, một người chỉ cần chạy lệnh sau để cài đặt toàn bộ theme và plugin được khai báo trong `vimrc`:

```sh
vim +PlugInstall +qall
```

## fontconfig

Sau khi cài đặt thêm các font của Microsoft, fontconfig nhằm dùng để tinh chỉnh lại việc render font một tí cho phù hợp với sở thích của bản thân mình hơn. Đồng thời, nếu trên những Arch-based distribution thì có thể cài trực tiếp [freetype2-cleartype](https://aur.archlinux.org/packages/freetype2-cleartype/) từ AUR để có thể sử dụng Clear Type của Microsoft cho font rasterization (tùy sở thích mỗi người).

Ngoài ra, vì emoji trên Chrome của Linux mặc định sẽ không load được nên file 01-emoji.conf là nhằm dùng bộ font [noto-fonts-emoji](https://www.archlinux.org/packages/extra/any/noto-fonts-emoji/) của Google để giúp Chrome có thể render emoji. Mặt khác, vì một số ứng dụng cần bộ font DejaVu để thỏa mãn dependencies của ứng dụng đó mà font DejaVu lại làm cho emoji render lỗi nên cần phải tạo ra thêm một file 70-no-dejavu.conf để black-list font DejaVu.

## neofetch

Vì mình dùng GNOME và dùng theme Yaru của Ubuntu (vì nó đẹp) nên mình chỉnh neofetch cho nó hiện ascii art thành Ubuntu cho vui :penguin:

