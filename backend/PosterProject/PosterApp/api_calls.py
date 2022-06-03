import magic 
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.proxy import *
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
import selenium.webdriver.support.expected_conditions as EC
import time


# decorator for measuring elapsed time
def time_this(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start} seconds")
        return result
    return wrapper


def get_mime_type(file):
    initial_pos = file.tell()
    file.seek(0)
    mime_type = magic.from_buffer(file.read(2048), mime=True)
    file.seek(initial_pos)
    return mime_type.split('/')[0]


def initialize_driver(headless=True, vpn=False):
    # TODO: run driver in another process
    capabilities = webdriver.DesiredCapabilities.CHROME
    options = webdriver.ChromeOptions()
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--ignore-ssl-errors')
    options.add_experimental_option('excludeSwitches', ['enable-logging'])
    if headless:
        options.add_argument('--headless')
    # options.add_argument('--disable-gpu')
    # options.add_argument('window-size=1920x1080')
    if vpn:
        options.add_extension(r'C:\Users\Luzif\AppData\Local\Google\Chrome\User Data\Default\Extensions\omghfjlpggmjjaagoclmmobgdodcjboh/3.50.0_0.crx')
    driver  = webdriver.Chrome(options=options, desired_capabilities=capabilities)

    return driver


def activate_vpn(driver):
    driver.get("chrome-extension://omghfjlpggmjjaagoclmmobgdodcjboh/popup/popup.html")
    time.sleep(5)
    driver.execute_script("document.querySelector('div.MainContainer page-switch').shadowRoot.querySelector('div.In main-index').shadowRoot.querySelector('div.Foot c-switch').click()")
    time.sleep(2)


@time_this
def send_post(post):
    # send post to platform
    if post.platform.platform == 'OK':
        driver = initialize_driver(headless=False)
        send_post_to_odnoklassniki(driver, post)
        driver.quit()
    if post.platform.platform == 'VK':
        driver = initialize_driver(headless=False)
        send_post_to_vkontakte(driver, post)
        driver.quit()
    if post.platform.platform == 'TW':
        driver = initialize_driver(headless=False, vpn=True)
        send_post_to_twitter(driver, post)
        driver.quit()


@time_this
def send_post_to_odnoklassniki(driver, post):
    phone = post.platform.phone_number
    password = post.platform.password
    driver.get("https://ok.ru/")
    time.sleep(5)
    login_field = driver.find_element(by=By.XPATH, value="//*[@id='field_email']")
    login_field.send_keys(phone)
    time.sleep(1)
    password_field = driver.find_element(by=By.XPATH, value="//*[@id='field_password']")
    password_field.send_keys(password)
    time.sleep(1)
    driver.find_element(by=By.XPATH, value="//*[@class='login-form-actions']/input").click()
    time.sleep(5)
    driver.find_element(by=By.CLASS_NAME, value="pf-head_itx_a").click()
    time.sleep(3)
    input = driver.find_element(by=By.XPATH, value="//*[@class='posting_itx-w']/div[2]")
    input.send_keys(post.text)
    time.sleep(3)
    submit_button = driver.find_element(by=By.XPATH, value="//*[@class='posting_f_ac']/div[2]")

    if post.media:
        if get_mime_type(post.media) == 'image':
            driver.find_element(by=By.XPATH, value="//*[@data-l='t,button.photo']").click()
            time.sleep(3)
            driver.find_element(by=By.XPATH, value="//*[@id='hook_Block_PopLayer']/div/photo-picker/div/div/div[2]/div/div[3]/div[2]/div[1]/span/input").send_keys(post.media.path)
            time.sleep(3)
        if get_mime_type(post.media) == 'video':
            # driver.find_element(by=By.XPATH, value="//*[@data-l='t,button.video']").click()
            # time.sleep(3)
            # driver.find_element(by=By.XPATH, value="//*[@id='hook_Block_PFVideoAttachUploadBlock']/div/div/div[2]/span/input").send_keys(post.media.path)
            # wait until submit button is enabled
            # WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, "//*[@class='posting_f_ac']/div[2]")))
            time.sleep(3)
            # time.sleep(10)
    submit_button.click()
    post.status = 'published'
    post.save()

@time_this
def send_post_to_vkontakte(driver, post):
    phone = post.platform.phone_number
    password = post.platform.password
    driver.get("https://vk.com/")
    time.sleep(5)
    driver.find_element(by=By.XPATH, value="//*[@id='index_login']/div/form/button").click()
    time.sleep(3)
    login_field = driver.find_element(by=By.XPATH, value="//*[@name='login']")
    login_field.send_keys(phone)
    login_field.send_keys(Keys.ENTER)
    time.sleep(2)
    password_field = driver.find_element(by=By.XPATH, value="//*[@name='password']")
    password_field.send_keys(password)
    password_field.send_keys(Keys.ENTER)
    time.sleep(5)
    input = driver.find_element(by=By.XPATH, value="//*[@id='post_field']")
    input.send_keys(post.text)
    if post.media:
        if get_mime_type(post.media) == 'image':
            driver.find_element(by=By.XPATH, value="//*[@id='page_add_media']/div[1]/a[1]").click()
            time.sleep(3)
            driver.find_element(by=By.XPATH, value="//*[@id='photos_upload_input_729012740_-14']").send_keys(post.media.path)
        if get_mime_type(post.media) == 'video':
            driver.find_element(by=By.XPATH, value="//*[@id='page_add_media']/div[1]/a[2]").click()
            time.sleep(3)
            driver.find_element(by=By.XPATH, value="//*[@id='choose_video_upload']/input").send_keys(post.media.path)
        time.sleep(5)


    action = ActionChains(driver)
    action.key_down(Keys.CONTROL)
    action.send_keys(Keys.ENTER)
    action.key_up(Keys.CONTROL)
    action.perform()
    time.sleep(1)
    post.status = 'published'
    post.save()


@time_this
def send_post_to_twitter(driver, post):
    activate_vpn(driver)
    email = post.platform.email
    password = post.platform.password
    driver.get('https://twitter.com/i/flow/login')
    time.sleep(10)
    login_field = driver.find_element(by=By.XPATH, value="//*[@id='react-root']/div/div/div/div/div/div/div/div/div/div[2]/div[2]/div/div/div[2]/div[2]/div/div/div/div[5]/label/div/div[2]/div/input")
    time.sleep(1)
    login_field.send_keys(email)
    login_field.send_keys(Keys.ENTER)
    time.sleep(5)
    password_field = driver.find_element(by=By.NAME, value="password")
    time.sleep(1)
    password_field.send_keys(password)
    password_field.send_keys(Keys.ENTER)
    time.sleep(5)
    driver.get('https://twitter.com/compose/tweet')
    time.sleep(10)
    input_field = driver.find_element(by=By.XPATH, value="//*[@class='DraftEditor-editorContainer']/div")
    time.sleep(5)
    input_field.send_keys(post.text)
    print(post.media.path if post.media else '')
    if post.media and get_mime_type(post.media) == 'image':
        driver.find_element(by=By.XPATH,
        value="//*[@id='layers']/div[2]/div/div/div/div/div/div[2]/div[2]/div/div/div/div[3]/div/div[1]/div/div/div/div/div[2]/div[3]/div/div/div[1]/input").send_keys(post.media.path)
        time.sleep(5)

    action = ActionChains(driver)
    action.key_down(Keys.CONTROL)
    action.send_keys(Keys.ENTER)
    action.key_up(Keys.CONTROL)
    action.perform()
    time.sleep(5)
    post.status = 'published'
    post.save()

@time_this
def send_post_to_facebook(driver, post):
    activate_vpn(driver)
    phone = post.platform.phone_number
    password = post.platform.password
    driver.get('https://www.facebook.com/')
    driver.find_element(by=By.ID, value="email").send_keys(phone)
    time.sleep(3)
    driver.find_element(by=By.ID, value="pass").send_keys(password, Keys.ENTER)
    time.sleep(8)
    driver.get('https://www.facebook.com/profile.php')

    driver.find_element(by=By.XPATH, value="//*[@data-pagelet='ProfileComposer']/div/div/div/div/div[1]/div").click()
    time.sleep(10)
    driver.find_element(by=By.XPATH, value="//*[@role='presentation']/div[1]/div/div/div").send_keys(post.text)
    time.sleep(5)
    driver.find_element(by=By.XPATH, value="//*[@aria-label='Опубликовать']").click()
    time.sleep(5)
