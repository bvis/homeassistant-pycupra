"""Diagnostics support for PyCupra."""

from __future__ import annotations

from typing import TYPE_CHECKING, Any

from homeassistant.components.diagnostics import async_redact_data
from homeassistant.const import CONF_PASSWORD, CONF_USERNAME

if TYPE_CHECKING:
    from homeassistant.config_entries import ConfigEntry
    from homeassistant.core import HomeAssistant

from .const import CONF_SPIN, CONF_VEHICLE, DATA, DOMAIN

TO_REDACT_CONFIG = {
    CONF_USERNAME,
    CONF_PASSWORD,
    CONF_SPIN,
    CONF_VEHICLE,
}

TO_REDACT_DATA = {
    "vin",
    "VIN",
    "latitude",
    "longitude",
    "lat",
    "lng",
    "position",
    "parkingposition",
    "email",
    "address",
}


async def async_get_config_entry_diagnostics(hass: HomeAssistant, entry: ConfigEntry) -> dict[str, Any]:
    """Return diagnostics for a config entry."""
    pycupra_data = hass.data[DOMAIN][entry.entry_id][DATA]
    coordinator = pycupra_data.coordinator

    instruments_data = {}
    for instrument in pycupra_data.instruments:
        instruments_data[instrument.attr] = {
            "name": instrument.name,
            "component": instrument.component,
            "state": str(instrument.state),
            "unit": instrument.unit,
            "attributes": {k: str(v) for k, v in (instrument.attributes or {}).items()},
        }

    vehicle = coordinator.connection.vehicle(coordinator.vin)
    vehicle_data = {}
    if vehicle:
        vehicle_data = {
            "brand": vehicle.brand,
            "model": vehicle.model,
            "model_year": vehicle.model_year,
            "deactivated": vehicle.deactivated,
        }

    return {
        "config_entry": async_redact_data(entry.as_dict(), TO_REDACT_CONFIG),
        "vehicle": async_redact_data(vehicle_data, TO_REDACT_DATA),
        "instruments": {k: async_redact_data(v, TO_REDACT_DATA) for k, v in instruments_data.items()},
        "coordinator": {
            "last_update_success": coordinator.last_update_success,
            "update_interval": str(coordinator.update_interval),
        },
    }
