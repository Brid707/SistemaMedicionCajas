package com.cajas.service;

import com.cajas.dto.AuthResponse;
import com.cajas.dto.LoginRequest;
import com.cajas.dto.RegisterRequest;
import com.cajas.dto.UsuarioResponse;
import com.cajas.model.Usuario;
import com.cajas.repository.UsuarioRepository;
import com.cajas.security.JwtService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(
            UsuarioRepository usuarioRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService
    ) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    public AuthResponse registrar(RegisterRequest request) {
        if (usuarioRepository.existsByCorreo(request.correo())) {
            throw new RuntimeException("Ya existe una cuenta con ese correo");
        }

        Usuario usuario = new Usuario(
                request.nombre(),
                request.correo().toLowerCase(),
                passwordEncoder.encode(request.password())
        );

        Usuario usuarioGuardado = usuarioRepository.save(usuario);
        String token = jwtService.generarToken(usuarioGuardado);

        return new AuthResponse(
                token,
                usuarioGuardado.getId(),
                usuarioGuardado.getNombre(),
                usuarioGuardado.getCorreo()
        );
    }

    public AuthResponse login(LoginRequest request) {
        Usuario usuario = usuarioRepository.findByCorreo(request.correo().toLowerCase())
                .orElseThrow(() -> new RuntimeException("Correo o contraseña incorrectos"));

        boolean passwordCorrecta = passwordEncoder.matches(
                request.password(),
                usuario.getPassword()
        );

        if (!passwordCorrecta) {
            throw new RuntimeException("Correo o contraseña incorrectos");
        }

        String token = jwtService.generarToken(usuario);

        return new AuthResponse(
                token,
                usuario.getId(),
                usuario.getNombre(),
                usuario.getCorreo()
        );
    }

    public UsuarioResponse obtenerUsuarioActual(Usuario usuario) {
        return new UsuarioResponse(
                usuario.getId(),
                usuario.getNombre(),
                usuario.getCorreo()
        );
    }
}
