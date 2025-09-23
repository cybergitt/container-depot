# Keycloak docker compose file

This is a simple docker-compose file to install Keycloak for different environments.

### Remember

You need to set the environment variables for this to work properly.
The .env.example contains the variables I am using. Copy it and remove the .example.
Remember to also set the KEYCLOAK_URL variable to your host's name.

### Generate self-signed certificates

You can generate self-signed certificates for development purpose by using this command.

```bash
./generate-selfsigned-with-san.sh keycloak.local myapp.local '*.example.com'
```