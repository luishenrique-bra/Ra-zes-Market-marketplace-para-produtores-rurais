package br.com.marketplace.utils;

import java.util.regex.Pattern;

public class EmailValidador {
    
    private static final int TAMANHO_MAXIMO = 100;

    private static final Pattern PADRAO_EMAIL = Pattern.compile(
            "^[A-Za-z0-9_%+-]+(\\.[A-Za-z0-9_%+-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*\\.[A-Za-z]{2,}$");

    public static boolean isVazio(String email) {
        return email == null || email.trim().isEmpty();
    }

    public static boolean isEmail(String email) {
        if (isVazio(email)) return false;
        email = email.trim();
        return email.length() <= TAMANHO_MAXIMO && PADRAO_EMAIL.matcher(email).matches();
    }
}
