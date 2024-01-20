% 1. Leitura do arquivo de áudio
caminho_arquivo = 'audio_gravado.wav';
[y, fs] = audioread(caminho_arquivo);

% 2. Plotagem do sinal no domínio do tempo
tempo = (0:length(y)-1) / fs;
figure;
subplot(2,1,1);
plot(tempo, y);
title('Sinal de Voz no Domínio do Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Amostragem

% Configuração da amostragem
fator_amostragem = 2;  % Fator de amostragem, ou seja, a cada quantas amostras você deseja manter

% Realiza a amostragem
y_amostrado = y(1:fator_amostragem:end);

% Tempo original e tempo amostrado
tempo_original = (0:length(y)-1) / fs;
tempo_amostrado = (0:length(y_amostrado)-1) / (fs / fator_amostragem);

% Plota o sinal original e o sinal amostrado
subplot(2,1,1);
plot(tempo_original, y);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(2,1,2);
stem(tempo_amostrado, y_amostrado, 'r');
title('Sinal Amostrado');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Reproduz o áudio original para comparação
% sound(y, fs);

% Quantização
% A quantização é o processo de representar os valores de amplitude do
% sinal em um número finito de níveis discretos.

% Número de bits de quantização
num_bits = 8; % Altere conforme necessário

% Limite superior e inferior para a quantização
limite_superior = max(y_amostrado);
limite_inferior = min(y_amostrado);

% Intervalo entre os níveis de quantização
intervalo_quantizacao = (limite_superior - limite_inferior) / (2^num_bits);

% Realiza a quantização
y_quantizado = round((y_amostrado - limite_inferior) / intervalo_quantizacao) * intervalo_quantizacao + limite_inferior;

% Plota o sinal amostrado e o sinal quantizado
figure;

subplot(2,1,1);
stem(tempo_amostrado, y_amostrado, 'r');
title('Sinal Amostrado');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(2,1,2);
stem(tempo_amostrado, y_quantizado, 'b');
title('Sinal Quantizado');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Reproduz o áudio quantizado para comparação
sound(y_quantizado, fs);

% Codificação DPCM

delta = intervalo_quantizacao; % Passo de quantização
y_dpcm = zeros(size(y_quantizado));
prev_sample = y_quantizado(1);

for i = 2:length(y_quantizado)
    diff = y_quantizado(i) - prev_sample;
    codeword = round(diff / delta);
    reconstructed_sample = prev_sample + codeword * delta;
    
    y_dpcm(i) = reconstructed_sample;
    
    prev_sample = reconstructed_sample;
end

% Plota o sinal quantizado e o sinal DPCM
figure;

subplot(2,1,1);
stem(tempo_amostrado, y_quantizado, 'b');
title('Sinal Quantizado');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(2,1,2);
stem(tempo_amostrado, y_dpcm, 'g');
title('Sinal DPCM');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Reproduz o áudio DPCM para comparação
sound(y_dpcm, fs);

% Filtro passa baixa antes da modulação

% Parâmetros do filtro passa-baixa
frequencia_corte = 4000; % Frequência de corte em Hz
ordem_filtro = 6; % Ordem do filtro

% Projeta o filtro passa-baixa
filtro_passa_baixa = designfilt('lowpassfir', 'FilterOrder', ordem_filtro, 'CutoffFrequency', frequencia_corte, 'SampleRate', fs);

% Aplica o filtro passa-baixa no sinal DPCM
sinal_modulante_filtrado = filtfilt(filtro_passa_baixa, sinal_modulante);