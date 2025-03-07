package com.example.health.check;

import java.util.Date;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import org.springframework.stereotype.Component;
import io.jsonwebtoken.*;

@Component
public class JwtUtil {

    private String secretKey = "mySuperSecretKeyThatIsLongEnoughToBeSecure!";
    
    // Create the SecretKey used for signing the JWT
    SecretKey key = new SecretKeySpec(secretKey.getBytes(), SignatureAlgorithm.HS256.getJcaName());

    // Generate Token
    public String generateToken(String email) {
        return Jwts.builder()
                .setSubject(email)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60)) // 1 hour expiry
                .signWith(key)
                .compact();
    }

    // Validate Token (checks both validity and expiration)
    @SuppressWarnings("deprecation")
    public boolean validateToken(String token) {
        try {
            // Using the newer API with parserBuilder() and setting the signing key
            JwtParser jwtParser = Jwts.parser()
                                      .setSigningKey(key)  // Set the signing key for validation
                                      .build();

            // Parse the JWT, this will throw an exception if the token is invalid or expired
            jwtParser.parseClaimsJws(token);
            return true; // Token is valid

        } catch (ExpiredJwtException e) {
            return false; // Token is expired
        } catch (JwtException e) {
            return false; // Token is invalid
        }
    }
}
