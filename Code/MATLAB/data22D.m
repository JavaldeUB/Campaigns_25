function [dist3D] = data22D(data)

% Extraer coordenadas
lat = data.lat;
lon = data.long;
alt = data.alt;  % en metros, asumo

% Punto de referencia
lat0 = lat(1);
lon0 = lon(1);
alt0 = alt(1);

% Constantes
R = 6371000; % Radio de la Tierra en metros

% Diferencias angulares
dLat = deg2rad(lat - lat0);
dLon = deg2rad(lon - lon0);
lat0_rad = deg2rad(lat0);

% Proyección en plano local
x = R * dLon .* cos(lat0_rad);  % este-oeste
y = R * dLat;                   % norte-sur
z = alt - alt0;                 % vertical

% Distancia euclídea 3D desde el primer punto
dist3D = sqrt(x.^2 + y.^2 + z.^2);

% Opcional: visualizar
figure;
plot(dist3D);
xlabel('Índice del punto');
ylabel('Distancia euclídea desde el primer punto (m)');
title('Distancia 3D desde el punto inicial');
end

