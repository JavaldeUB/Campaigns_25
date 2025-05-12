% Script para extraer los dos primeros números de líneas específicas en un CSV

% Paso 1: Seleccionar archivo
[filename, pathname] = uigetfile('*.csv', 'Selecciona el archivo CSV');
if isequal(filename, 0)
    disp('No se seleccionó ningún archivo. Se cancela el proceso.');
    return;
end
filepath = fullfile(pathname, filename);

% Paso 2: Inicializar vectores
val1 = [];
val2 = [];

% Paso 3: Abrir y leer línea por línea
fid = fopen(filepath, 'r');
if fid == -1
    error('No se pudo abrir el archivo.');
end

while ~feof(fid)
    line = fgetl(fid);
    
    % Verificar si la línea contiene el patrón exacto
    pattern = 'Received by board: MES: gas_levels =';
    if startsWith(line, pattern)
        % Extraer números
        numbers = sscanf(line(length(pattern)+1:end), '%d');
        if length(numbers) >= 2
            val1(end+1) = numbers(1); %#ok<SAGROW>
            val2(end+1) = numbers(2); %#ok<SAGROW>
        end
    end
end

fclose(fid);

% Mostrar resultado (puedes quitar esto si no lo necesitas)
disp('Primer vector (val1):');
disp(val1');
disp('Segundo vector (val2):');
disp(val2');
