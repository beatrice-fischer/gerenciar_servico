@ECHO OFF
SETLOCAL

SET "PROCESSO_ALVO=notepad.exe"
SET "TEMPO_MONITORAMENTO=10"
SET "CONTADOR=0"

ECHO ======================================================
ECHO  Monitoramento de: %PROCESSO_ALVO%
ECHO ======================================================

:LOOP_MONITORAMENTO
SET /A CONTADOR+=1

ECHO.
ECHO [%TIME%] Tentativa #%CONTADOR%: Verificando status...

:: 1. VERIFICA SE O PROCESSO ESTA RODANDO
:: TASKLIST filtra a lista de processos. FIND define ERRORLEVEL=0 se a string for encontrada.
TASKLIST /FI "IMAGENAME eq %PROCESSO_ALVO%" | FIND /I "%PROCESSO_ALVO%" > NUL

:: 2. VERIFICA O CODIGO DE RETORNO (ERRORLEVEL)
IF %ERRORLEVEL% EQU 0 (
    :: O processo foi encontrado (está rodando)
    ECHO [STATUS OK] %PROCESSO_ALVO% esta ativo.
) ELSE (
    :: O processo NAO foi encontrado (foi fechado)
    ECHO [ALERTA] %PROCESSO_ALVO% Nao encontrado! Tentando reiniciar...
    
    :: Usa START para reabrir o aplicativo
    START "" "%PROCESSO_ALVO%"
    
    ECHO [ACAO] Processo %PROCESSO_ALVO% iniciado novamente.
)

:: 3. PAUSA POR 10 SEGUNDOS antes da proxima verificacao
ECHO.
ECHO Proxima checagem em %TEMPO_MONITORAMENTO% segundos...
TIMEOUT /T %TEMPO_MONITORAMENTO% /NOBREAK

:: 4. RETORNA AO INICIO DO LOOP
GOTO LOOP_MONITORAMENTO

:FINALIZAR
PAUSE