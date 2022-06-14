% (x ^ y) % 9

z = 64;
[x, y] = meshgrid(1:z,  1:z);
a = mod(bitor(x(:),y(:)), 9);
a = reshape(a, z, z);