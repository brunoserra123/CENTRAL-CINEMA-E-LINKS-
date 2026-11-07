@echo off
title Atualizar Site no GitHub - Bruno Serra
cls
echo ======================================================
echo    PUBLICADOR AUTOMATICO DO SITE NO GITHUB PAGES
echo ======================================================
echo.

cd /d "C:\Users\brunoserra\Documents\CENTRAL-CINEMA-E-LINKS-"

echo [1/3] Verificando alteracoes...
git status -s

echo.
echo [2/3] Criando commit...
git add .
git commit -m "Atualizacao de links"

echo.
echo [3/3] Enviando para o GitHub...
git push origin main

echo.
if %errorlevel% equ 0 (
    echo ======================================================
    echo    SITE ATUALIZADO COM SUCESSO NO GITHUB!
    echo    Link: https://brunoserra123.github.io/CENTRAL-CINEMA-E-LINKS-/
    echo ======================================================
) else (
    echo ======================================================
    echo    OCORREU UM ERRO AO ENVIAR PARA O GITHUB!
    echo ======================================================
)

echo.
pause
