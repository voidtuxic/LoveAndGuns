require('gamescreen')
require('startscreen')
require('gameoverscreen')
require('sound')

spacekeypress = false

-- Shader courtesy of BlackBulletIV - https://gist.github.com/BlackBulletIV/4218802
glow = love.graphics.newPixelEffect([[
   extern vec2 size;
   extern int samples = 5; // pixels per axis; higher = bigger glow, worse performance
   extern float quality = 2.5; // lower = smaller glow, better quality
    
   vec4 effect(vec4 colour, Image tex, vec2 tc, vec2 sc)
   {
     vec4 source = Texel(tex, tc);
     vec4 sum = vec4(0);
     int diff = (samples - 1) / 2;
     vec2 sizeFactor = vec2(1) / size * quality;
     
     for (int x = -diff; x <= diff; x++)
     {
       for (int y = -diff; y <= diff; y++)
       {
         vec2 offset = vec2(x, y) * sizeFactor;
         sum += Texel(tex, tc + offset);
       }
     }
     
     return ((sum / (samples * samples)) + source) * colour;
   }
   ]])
-- courtesy of vrld - http://www.love2d.org/forums/viewtopic.php?f=4&t=3733
chroma = love.graphics.newPixelEffect([[
    extern vec2 chroma;
    extern vec2 imageSize;

    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
    {
       vec2 shift = chroma / imageSize;
       return vec4(Texel(tex, tc+shift).r, Texel(tex,tc).g, Texel(tex,tc-shift).b, 1.0);
    }
   ]])

function love.load()
   -- font courtesy of Ænigma - http://www.dafont.com/fr/visitor.font
   mainFont = love.graphics.newFont("visitor1.ttf", 30);
   screen = StartScreen.create(mainFont)
   Sounds.shoot:setVolume(0.2)
   Sounds.boom:setVolume(0.5)
   canvas1 = love.graphics.newCanvas()
   canvas2 = love.graphics.newCanvas()
   glow:send("size", {1024,768})
   chroma:send("imageSize", {1024,768})
   chromavariation = 0
end

function love.update(dt)
   screen:update(dt)
   if screen.title == "start" and love.keyboard.isDown(' ') and not spacekeypress then
      screen = GameScreen.create()
   end
   if screen.title == "game" and screen.player.life <= 0 then
      screen = GameOverScreen.create(mainFont, screen.player.score)
   end
   if screen.title == "gameover" and love.keyboard.isDown(' ') and not spacekeypress then
      screen = StartScreen.create(mainFont)
   end
   spacekeypress = love.keyboard.isDown(' ')
   chromavariation = chromavariation + 0.01
   chroma:send("chroma", {math.cos(chromavariation)*4,0}) -- vomit hipster effect
end

function love.draw()
   love.graphics.setPixelEffect() -- no effects on rendering, ain't good, see
   canvas1:clear() -- clear the sh*t out of this buffer to prevent trailing
   love.graphics.setCanvas(canvas1) -- drawing to off screen buffer for 1st post process pass
   screen:draw()

   canvas2:clear() -- on to 1st post process pass
   love.graphics.setCanvas(canvas2)
   love.graphics.setPixelEffect(chroma) -- HEAVY CHROMA YEAH
   love.graphics.draw(canvas1, 0,0)

   love.graphics.setCanvas() -- going back to screen buffer
   love.graphics.setPixelEffect(glow) -- glow everything!
   love.graphics.draw(canvas2, 0,0)
end