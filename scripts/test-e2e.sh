#!/usr/bin/env bash
# Interactive E2E test against the real Cupra/SEAT API.
# Requires credentials via environment variables.
#
# Usage:
#   CUPRA_USERNAME=user@example.com CUPRA_PASSWORD=secret CUPRA_BRAND=cupra ./scripts/test-e2e.sh
#
# Or with Docker:
#   docker run --rm -it \
#     -e CUPRA_USERNAME -e CUPRA_PASSWORD -e CUPRA_BRAND \
#     -v $(pwd):/workspace -w /workspace pycupra-dev \
#     ./scripts/test-e2e.sh

set -e

: "${CUPRA_USERNAME:?Set CUPRA_USERNAME env var}"
: "${CUPRA_PASSWORD:?Set CUPRA_PASSWORD env var}"
: "${CUPRA_BRAND:=cupra}"

echo "Testing connection to ${CUPRA_BRAND} API..."
echo "Username: ${CUPRA_USERNAME}"
echo "Brand: ${CUPRA_BRAND}"
echo ""

python3 -c "
import asyncio
import aiohttp

from pycupra.connection import Connection

async def main():
    async with aiohttp.ClientSession() as session:
        conn = Connection(
            session=session,
            brand='${CUPRA_BRAND}',
            username='${CUPRA_USERNAME}',
            password='${CUPRA_PASSWORD}',
        )
        print('Logging in...')
        await conn.doLogin()
        print('Login successful!')

        print('Fetching vehicles...')
        vehicles = conn.vehicles
        print(f'Found {len(vehicles)} vehicle(s)')

        for vehicle in vehicles:
            print(f'  VIN: {vehicle.vin}')
            print(f'  Model: {vehicle.model}')
            print(f'  Brand: {vehicle.brand}')
            print(f'  Nickname: {vehicle.nickname}')
            print()

            print('  Updating vehicle data...')
            await vehicle.update()
            dashboard = vehicle.dashboard()
            instruments = dashboard.instruments
            print(f'  Found {len(instruments)} instruments:')
            for inst in instruments:
                print(f'    {inst.component}/{inst.attr}: {inst.state} {inst.unit or \"\"}')
            print()

        await conn.doLogout()
        print('Logout successful!')

asyncio.run(main())
"
