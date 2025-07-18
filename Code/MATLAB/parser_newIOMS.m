% Seleccionar archivo con ventana
defaultFileName = 'datos_sensores.csv';
[filename, pathname] = uigetfile('*.csv', 'Selecciona el archivo CSV', defaultFileName);
if isequal(filename,0)
    disp('No se seleccionó ningún archivo.');
    return;
end
filePath = fullfile(pathname, filename);

% Leer archivo línea a línea
fid = fopen(filePath, 'r');
resultados_ECS = [];
tant_ECS = 0;

disp("Parsing ECS data");
while ~feof(fid)
    linea = fgetl(fid);
    if ischar(linea)
        partes = strsplit(linea, '"');
        if length(partes) == 5
            timestamp = strip(partes{1},',');
            sensores = strip(partes{2},'!');
            gps = partes{4};

            % Verificar si la línea contiene "ECS"
            if contains(sensores, 'ECS')
                subpartes = strsplit(sensores, '#');

                % Extraer datos de los sensores
                num_medidas = length(subpartes)-3;
                medidas = [];
                count = 0;
                for j = 1:num_medidas
                    datos = str2double(strsplit(subpartes{j + 1}, ','));
                    if length(datos)==5
                        medidas(count+1,:) = datos;
                        count = count+1;
                    end
                end

                % Extraer temperatura y humedad
                trh_datos = str2double(strsplit(subpartes{end}, ','));
                trh_repetido = repmat(trh_datos, count, 1);
                medidas = cat(2,medidas,trh_repetido);
                if length(trh_datos)==4
                % Extraer datos GPS
                    gps_datos = strsplit(gps, ',');
                    for j =2:length(gps_datos)
                        gps_loc(j)=str2double(gps_datos{j});
                    end
                    gps_locR = repmat(gps_loc(2:end), count, 1);
                    medidas = cat(2,medidas,gps_locR);

                    if tant_ECS == 0
                        t = second(gps_datos{1})-(count/2):0.5:second(gps_datos{1})-0.5;
                        tant_ECS = gps_datos{1};
                    else
                        deltat = seconds(datetime(gps_datos{1})-datetime(tant_ECS))/(count);
                        t = resultados_ECS(end:end):deltat:resultados_ECS(end:end)+deltat*(count)-deltat;
                        tant_ECS = gps_datos{1};
                    end
                    medidas = cat(2,medidas,t.');
                    % Guardar fila procesada
                    resultados_ECS = cat(1,resultados_ECS,medidas);
                end
            end
        end
    end
end

fclose(fid);

resultados_cell = num2cell(resultados_ECS);

% Seleccionar archivo con ventana
defaultFileName = 'datosECS.csv';
[filename_r, pathname_r] = uiputfile('*.csv', 'Guardar archivo CSV como', defaultFileName);
if isequal(filename,0)
    disp('No folder selected.');
    return;
end
filePath_r = fullfile(pathname_r, filename_r);

% Crear tabla con las cabeceras especificadas
headers = {'H2SH', 'H2SL', 'NH3', 'PIDmV', 'PIDppm', 'T1', 'RH1', 'T2', 'RH2', 'LAT', 'LONG', 'ALT', 'ACC', 't'};
tabla = cell2table(resultados_cell, 'VariableNames', headers);

% Guardar la tabla en CSV
writetable(tabla, filePath_r);

disp(['ECS data parsed and CSV stored in: ', filePath_r]);

disp("Parsing MXA data");
% Leer archivo línea a línea
fid = fopen(filePath, 'r');
resultados_MXA = [];
tant_MXA = 0;

while ~feof(fid)
    linea = fgetl(fid);
    if ischar(linea)
        partes = strsplit(linea, '"');
        if length(partes) == 5
            timestamp = strip(partes{1},',');
            sensores = strip(partes{2},'!');
            gps = partes{4};
        
            % Verificar si la línea contiene "ECS"
            if contains(sensores, 'MXA')
                subpartes = strsplit(sensores, '#');
            
                % Extraer datos de los sensores
                num_medidas = length(subpartes)-3;
                medidas = [];
                count = 0;
                for j = 1:num_medidas
                    datos = str2double(strsplit(subpartes{j + 1}, ','));
                    if length(datos)==4
                        medidas(count+1,:) = datos;
                        count = count+1;
                    end
                end
            
                % Extraer temperatura y humedad
                trh_datos = str2double(strsplit(subpartes{end}, ','));
                trh_repetido = repmat(trh_datos, (count), 1);
                medidas = cat(2,medidas,trh_repetido);
                if length(trh_datos)==8
                    % Extraer datos GPS
                    gps_datos = strsplit(gps, ',');
                    for j =2:length(gps_datos)
                        gps_loc(j)=str2double(gps_datos{j});
                    end
                    gps_locR = repmat(gps_loc(2:end), (count), 1);
                    medidas = cat(2,medidas,gps_locR);

                    if tant_MXA == 0
                        t = second(gps_datos{1})-(count):second(gps_datos{1})-1;               
                        tant_MXA = gps_datos{1};
                    else
                        deltat = seconds(datetime(gps_datos{1})-datetime(tant_MXA))/(count);
                        t = resultados_MXA(end:end):deltat:resultados_MXA(end:end)+deltat*(count)-deltat;
                        tant_MXA = gps_datos{1};                    
                    end
                    medidas = cat(2,medidas,t.');
                    % Guardar fila procesada
                    resultados_MXA = cat(1,resultados_MXA,medidas);
                end
            end
        end
    end
end

fclose(fid);

resultados_cell = num2cell(resultados_MXA);

% Seleccionar archivo con ventana
defaultFileName = 'datosMXA.csv';
[filename_r, pathname_r] = uiputfile('*.csv', 'Guardar archivo CSV como', defaultFileName);
if isequal(filename,0)
    disp('No folder selected.');
    return;
end
filePath_r = fullfile(pathname_r, filename_r);

% Crear tabla con las cabeceras especificadas
headers = {'TGS2600', 'TGS2602', 'TGS2611', 'TGS2620', 'T1', 'RH1', 'T2', 'RH2', 'T3', 'RH3', 'T4', 'RH4', 'LAT', 'LONG', 'ALT', 'ACC', 't'};
tabla = cell2table(resultados_cell, 'VariableNames', headers);

% Guardar la tabla en CSV
writetable(tabla, filePath_r);

disp(['MXA data parsed and CSV stored in: ', filePath_r]);

disp("Parsing MXD data");
% Leer archivo línea a línea
fid = fopen(filePath, 'r');
resultados_MXD = [];
tant_MXD = 0;

while ~feof(fid)
    linea = fgetl(fid);
    if ischar(linea)
        partes = strsplit(linea, '"');
        if length(partes) == 5
            timestamp = strip(partes{1},',');
            sensores = strip(partes{2},'!');
            gps = partes{4};
        
            % Verificar si la línea contiene "ECS"
            if contains(sensores, 'MXD')
                subpartes = strsplit(sensores, '#');
            
                % Extraer datos de los sensores
                num_medidas = length(subpartes)-3;
                medidas = [];
                count = 0;
                for j = 1:num_medidas
                    datos = str2double(strsplit(subpartes{j + 1}, ','));
                    if length(datos)==8
                        medidas(count+1,:) = datos;
                        count = count+1;
                    end
                end
            
                % Extraer temperatura y humedad
                trh_datos = str2double(strsplit(subpartes{end}, ','));
                trh_repetido = repmat(trh_datos, (count), 1);
                medidas = cat(2,medidas,trh_repetido);
                if length(trh_datos)==8
                    % Extraer datos GPS
                    gps_datos = strsplit(gps, ',');
                    for j =2:length(gps_datos)
                        gps_loc(j)=str2double(gps_datos{j});
                    end
                    gps_locR = repmat(gps_loc(2:end), (count), 1);
                    medidas = cat(2,medidas,gps_locR);

                    if tant_MXD == 0
                        t = second(gps_datos{1})-(count):second(gps_datos{1})-1;                    
                        tant_MXD = gps_datos{1};
                    else
                        deltat = seconds(datetime(gps_datos{1})-datetime(tant_MXD))/(count);
                        t = resultados_MXD(end:end):deltat:resultados_MXD(end:end)+deltat*(count)-deltat;
                        tant_MXD = gps_datos{1};                    
                    end
                    medidas = cat(2,medidas,t.');
                    % Guardar fila procesada
                    resultados_MXD = cat(1,resultados_MXD,medidas);
                end
            end
        end
    end
end

fclose(fid);

resultados_cell = num2cell(resultados_MXD);

% Seleccionar archivo con ventana
defaultFileName = 'datosMXD.csv';
[filename_r, pathname_r] = uiputfile('*.csv', 'Guardar archivo CSV como', defaultFileName);
if isequal(filename,0)
    disp('No folder selected.');
    return;
end
filePath_r = fullfile(pathname_r, filename_r);

% Crear tabla con las cabeceras especificadas
headers = {'SGP1', 'SGP2', 'ENS1', 'ENS2', 'ENS3', 'ENS4', 'BME', 'SCD', 'T1', 'RH1', 'T2', 'RH2', 'T3', 'RH3', 'T4', 'RH4', 'LAT', 'LONG', 'ALT', 'ACC', 't'};
tabla = cell2table(resultados_cell, 'VariableNames', headers);

% Guardar la tabla en CSV
writetable(tabla, filePath_r);

disp(['MXA data parsed and CSV stored in: ', filePath_r]);
