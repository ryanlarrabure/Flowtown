@step('I press "(.*)"')
def i_press_blank(step, number):
    ovbx.outgoing_data.update({"Digits":number})
    assert_open_and_read(ovbx.current_url)
