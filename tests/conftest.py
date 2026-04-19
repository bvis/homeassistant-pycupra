"""Shared test fixtures for PyCupra tests."""

from unittest.mock import MagicMock

import pytest


@pytest.fixture
def mock_vehicle():
    """Create a mock vehicle object."""
    vehicle = MagicMock()
    vehicle.vin = "WVWZZZ1KZAP000001"
    vehicle.nickname = "Test Cupra"
    vehicle.brand = "cupra"
    vehicle.model = "Born"
    vehicle.model_year = "2024"
    vehicle.battery_level = 75
    vehicle.charging = False
    vehicle.deactivated = False
    vehicle.is_model_image_small_supported = False
    vehicle.is_model_image_large_supported = False
    return vehicle


@pytest.fixture
def mock_instrument(mock_vehicle):
    """Create a mock instrument object."""
    instrument = MagicMock()
    instrument.attr = "test_sensor"
    instrument.name = "Test Sensor"
    instrument.component = "sensor"
    instrument.state = 42
    instrument.unit = "%"
    instrument.device_class = None
    instrument.icon = "mdi:car"
    instrument.attributes = {}
    instrument.vehicle = mock_vehicle
    instrument.vehicle_name = "WVWZZZ1KZAP000001"
    instrument.is_on = True
    instrument.is_locked = True
    instrument.mutable = True
    instrument.assumed_state = True
    instrument.callback = None
    return instrument


@pytest.fixture
def mock_data(mock_instrument):
    """Create a mock PyCupraData object."""
    data = MagicMock()
    data.instruments = [mock_instrument]
    data.coordinator = MagicMock()
    data.coordinator.data = True
    data.coordinator.last_update_success = True
    data.instrument = MagicMock(return_value=mock_instrument)
    data.vehicle_name = MagicMock(return_value="Test Cupra Born")
    return data
