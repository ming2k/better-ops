FROM debian:12-slim

# Install essential packages
RUN apt-get update && apt-get install -y \
    git \
    sudo \
    curl \
    wget \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Create test user
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /better-ops

# Copy source code
COPY . .

# Set ownership
RUN chown -R testuser:testuser /better-ops

# Switch to test user
USER testuser

# Default command runs main installation
# CMD ["./bin/main.sh"]