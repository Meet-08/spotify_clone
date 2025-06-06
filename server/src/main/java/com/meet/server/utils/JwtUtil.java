package com.meet.server.utils;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.UUID;

@Component
@Scope(value = "singleton")
public class JwtUtil {

    @Value("${spring.application.Jwt.secret}")
    private String JWT_SECRET;

    public String createToken(UUID id) {
        return JWT.create()
                .withSubject(id.toString())
                .withIssuer("Meet")
                .withExpiresAt(new Date(System.currentTimeMillis() + 1000L * 60 * 60 * 24 * 7))
                .sign(Algorithm.HMAC256(JWT_SECRET));
    }

    public DecodedJWT verifyToken(String token) {
        return JWT.require(Algorithm.HMAC256(JWT_SECRET))
                .withIssuer("Meet")
                .build()
                .verify(token);
    }
}
