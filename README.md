# oh-my-zsh-custom
The custom folder of my oh-my-zsh configuration

He incluido el segmento para powerline que modifica el prompt en repositorios git para mostrar + info
y que está en mi repo http://guilu.github.io/powerline-segment-ohmygit/. Al actualizarme a yosemite he tenido que hacer
unas modificaciones para que vuelva a quedar como antes:

<img src="http://guilu.github.io/powerline-segment-ohmygit/images/ohmygit-2.v2.0.png" width="700">


##Installation

Sobreescribir la carpeta custom dentro del directorio .oh-my-zsh

##Configuration

Para que el segmento funcione hay que crear un enlace simbólico en la carpeta de powerline a esta del custom, así como 
la configuracion del powerline que está en la documentación...
```
cd ~ && mkdir .config && cd .config
ln -s ~/.oh-my-zsh/custom/plugins/powerline powerline

cd ~/Library/Python/2.7/lib/python/site-packages/powerline/segments/
ln -s ~/.oh-my-zsh/custom/plugins/powerline/segments/dbh dbh
```
y ya podrás configurar las opciones de powerline con los ficheros colors.json, themes, etc...
