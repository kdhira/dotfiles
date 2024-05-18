#!/usr/bin/env python3
import iterm2
import datetime
from dateutil import tz

def to_html(text):
    return "<pre>" + text.replace("&", "&amp;").replace("<", "&lt;") + "</pre>"
def time_at(timezone, show_seconds):
    date_format = '%d/%m/%Y %H:%M' + (':%S' if show_seconds else '') + ' %Z'
    return datetime.datetime.now().astimezone(tz.gettz(timezone)).strftime(date_format)

async def main(connection):
    app = await iterm2.async_get_app(connection)

    knob_timezone = iterm2.StringKnob('Timezone', 'UTC', '', 'knob_timezone')
    knob_show_seconds = iterm2.CheckboxKnob('Show Seconds', False, 'knob_show_seconds')
    knobs = [knob_timezone, knob_show_seconds]
    component = iterm2.StatusBarComponent(
        short_description="Clock with Timezone",
        detailed_description="Custom clock with configurable timezone",
        knobs=knobs,
        exemplar="01/01/2000 00:00:00 UTC",
        update_cadence=1,
        identifier="com.iterm2.example.timezoneclock")

    # This function gets called once per second.
    @iterm2.StatusBarRPC
    async def coro(knobs):
        return time_at(knobs.get('knob_timezone'), knobs.get('knob_show_seconds'))

    # Register the component.
    await component.async_register(connection, coro)

iterm2.run_forever(main)
