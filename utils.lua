module(..., package.seeall);

-- courtesy of Substitute541 - http://www.love2d.org/wiki/DistanceBasedCollision
function checkCircularCollision(ax, ay, bx, by, ar, br)
    local dx = bx - ax
    local dy = by - ay
    local dist = math.sqrt(dx * dx + dy * dy)
    return dist < ar + br
end

-- courtesy of Taehl - http://www.love2d.org/wiki/General_math
function clamp(low, n, high) return math.min(math.max(n, low), high) end

-- ugly stuff happens here, you've been warned
function rotate(angle, x, y) 
    love.graphics.translate(x, y) -- center around object
    love.graphics.rotate(angle) -- rotate
    love.graphics.translate(-x, -y) -- put back the screen where it's supposed to be
end -- there has to be a better way