

library(ggplot2)
library(ggimage)
library(hexSticker)
library(magick)

fill="white"
color="black"
subplot="./Hex/pgradient2.jpg"
size=2.5
s_x=0.85
s_y=1.0
s_width=0.6
t_x=1
t_y=0.5
text.val="EPGMr"
t_color="black"
font.val="serif"
t_size=5

hexd <- data.frame(x = 1 + c(rep(-sqrt(3)/2, 2), 0, rep(sqrt(3)/2,2), 0), y = 1 + c(0.5, -0.5, -1, -0.5, 0.5, 1))
hexd <- rbind(hexd, hexd[1, ])
d <- data.frame(x = s_x, y = s_y, image =subplot)
d.txt <- data.frame(x = t_x, y = t_y, label = text.val)


#hex.stick=
  ggplot()+
  geom_polygon(aes_(x = ~x, y = ~y), data = hexd, size = size,fill = fill, color = color)+
  geom_image(aes_(x = ~x, y = ~y, image = ~image),d,size=0.5,by='width')+
  theme_sticker(size)+
  geom_text(aes_(x = 1, y = 0.5, label = text.val),size = t_size, color = t_color, family = font.val, fontface="bold" )

hex.stick
