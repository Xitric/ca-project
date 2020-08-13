#! /bin/bash
zip -r app.zip . -x .git/* ci/* environment/* test-reports/* docker-compose.yml
