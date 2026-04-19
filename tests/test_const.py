"""Tests for PyCupra constants."""

from custom_components.pycupra.const import DEFAULT_SCAN_INTERVAL, DOMAIN, MIN_SCAN_INTERVAL, PLATFORMS


def test_domain():
    """Test that the domain is correctly set."""
    assert DOMAIN == "pycupra"


def test_platforms_contains_expected_types():
    """Test that all expected platforms are defined."""
    expected = {"sensor", "binary_sensor", "lock", "device_tracker", "switch", "button", "climate", "number"}
    assert set(PLATFORMS.keys()) == expected


def test_scan_interval_bounds():
    """Test that scan intervals have sensible defaults."""
    assert MIN_SCAN_INTERVAL == 120
    assert DEFAULT_SCAN_INTERVAL == 600
    assert MIN_SCAN_INTERVAL < DEFAULT_SCAN_INTERVAL
