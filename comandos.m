% Configurações de gravação
taxa_amostragem = 44100; % Taxa de amostragem em Hz
duracao_segundos = 5;    % Duração da gravação em segundos
caminho_arquivo = 'audio_gravado.wav';

% Inicializa o objeto de gravação de áudio
gravador = audiorecorder(taxa_amostragem, 16, 1);

% Inicia a gravação
disp('Gravando...');
recordblocking(gravador, duracao_segundos);
disp('Gravação concluída.');

% Obtém os dados gravados
dados_audio = getaudiodata(gravador);

% Salva os dados em um arquivo WAV
audiowrite(caminho_arquivo, dados_audio, taxa_amostragem);

disp(['Áudio salvo em: ' caminho_arquivo]);

% Lê o arquivo de áudio
[y, fs] = audioread(caminho_arquivo);

% Usando soundsc (escalado automaticamente para um volume audível)
soundsc(y, fs);
