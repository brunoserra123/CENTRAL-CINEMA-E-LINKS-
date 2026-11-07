@echo off
chcp 65001 >nul
title Publicar no GitHub - Central de Cinema Bruno Serra
color 0b
echo ======================================================
echo   🚀 PUBLICADOR AUTOMÁTICO DO SITE NO GITHUB PAGES
echo ======================================================
echo.

cd /d "C:\Users\brunoserra\Documents\CENTRAL-CINEMA-E-LINKS-"

echo [1/3] Verificando arquivos alterados...
git status -s

echo.
echo [2/3] Adicionando alteracoes e criando commit...
git add .
git commit -m "Atualizacao de links: %date% %time%"

echo.
echo [3/3] Enviando para o GitHub (origin main)...
git push origin main

echo.
if %errorlevel% equ 0 (
    color 0a
    echo ======================================================
    echo   ✅ SITE ATUALIZADO COM SUCESSO NO GITHUB!
    echo   Link: https://brunoserra123.github.io/CENTRAL-CINEMA-E-LINKS-/
    echo ======================================================
) else (
    color 0c
    echo ======================================================
    echo   ❌ OCORREU UM ERRO AO ENVIAR PARA O GITHUB!
    echo ======================================================
)

echo.
echo Pressione qualquer tecla para fechar esta janela...
pause >nul
