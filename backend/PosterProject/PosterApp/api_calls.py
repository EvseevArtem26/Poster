import magic 
from selenium import webdriver
import selenium
from selenium.webdriver.common.by import By
from selenium.webdriver.common.proxy import *
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
import selenium.webdriver.support.expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException, ElementClickInterceptedException, TimeoutException
from py3pin.Pinterest import Pinterest

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
        options.add_extension(r'C:\Users\Luzif\AppData\Local\Google\Chrome\User Data\Default\Extensions\jaoafpkngncfpfggjefnekilbkcpjdgp\7.1.0_0.crx')
    driver  = webdriver.Chrome(options=options, desired_capabilities=capabilities)

    return driver


def activate_vpn(driver):
    driver.get("chrome-extension://jaoafpkngncfpfggjefnekilbkcpjdgp/popup/popup.html")
    p = driver.current_window_handle
    time.sleep(5)
    driver.switch_to.window(p)
    time.sleep(3)
    driver.find_element(by=By.XPATH, value="//*[@id='error']/main/div[2]/a").click()
    time.sleep(3)
    driver.find_element(by=By.XPATH, value="//*[@id='home']/div[2]/div[2]/div[1]").click()
    time.sleep(4)


@time_this
def send_post(post):
    # send post to platform
    if post.platform.platform == 'OK':
        driver = initialize_driver(headless=False)
        send_post_to_odnoklassniki(driver, post)
    if post.platform.platform == 'VK':
        driver = initialize_driver(headless=True)
        send_post_to_vkontakte(driver, post)
    if post.platform.platform == 'TW':
        driver = initialize_driver(headless=True, vpn=False)
        send_post_to_twitter(driver, post)
    if post.platform.platform == "PT":
        send_post_to_pinterest(post)

@time_this
def send_post_to_odnoklassniki(driver, post):
    url = 'https://ok.ru/'
    login_field_xpath = "//*[@id='field_email']"
    password_field_xpath = "//*[@id='field_password']"
    login_button_xpath = "//*[@class='login-form-actions']/input"
    post_form_classname = "pf-head_itx_a"
    text_field_xpath = "//*[@class='posting_itx-w']/div[2]"
    add_image_button_xpath = "//*[@data-l='t,button.photo']"
    image_upload_field_xpath = "//*[@id='hook_Block_PopLayer']/div/photo-picker/div/div/div[2]/div/div[3]/div[2]/div[1]/span/input"
    add_video_button_xpath = "//*[@data-l='t,button.video']"
    video_upload_field_xpath = "/html/body/div[17]/div/div[2]/div[1]/div/div[3]/div/div[1]/div/div/div[2]/span/input"
    submit_button_xpath = "//*[@class='posting_f_ac']/div[2]"
    

    phone = post.platform.phone_number
    password = post.platform.password

    if phone == '' or password == '':
        return

    try:
        driver.get(url)

        login_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=login_field_xpath))
        login_field.send_keys(phone)

        password_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=password_field_xpath))
        password_field.send_keys(password)

        login_button = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=login_button_xpath))
        login_button.click()

        post_form = WebDriverWait(driver, 20).until(lambda driver: driver.find_element(by=By.CLASS_NAME, value=post_form_classname))
        post_form.click()

        text_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=text_field_xpath))
        text_field.clear()
        text_field.send_keys(post.text)

        

        if post.media:
            if get_mime_type(post.media) == 'image':
                add_image_button = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=add_image_button_xpath))
                add_image_button.click()
                
                image_upload_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=image_upload_field_xpath))
                image_upload_field.send_keys(post.media.path)
                WebDriverWait(driver, 15).until(EC.element_to_be_clickable((By.XPATH, submit_button_xpath)))

                # WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value="//*[@id='hook_Block_pf2']/div[3]/div/ul/li/div[3]"))
                
            if get_mime_type(post.media) == 'video':
                add_video_button = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=add_video_button_xpath))
                add_video_button.click()
                
                video_upload_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=video_upload_field_xpath))
                print(post.media.path)
                video_upload_field.send_keys(post.media.path)
                time.sleep(30)
                # close_button = driver.find_element(by=By.XPATH, value="//*[@id='nohook_modal_close']")
                # close_button.click()
             
                # action = ActionChains(driver)
                # action.send_keys(Keys.ESCAPE)
                # action.perform()
                # time.sleep(5)
                # WebDriverWait(driver, 60,poll_frequency=5 ,ignored_exceptions=[NoSuchElementException, ElementClickInterceptedException]).until(EC.element_to_be_clickable((By.XPATH, submit_button_xpath)))
                WebDriverWait(driver, 60).until(lambda driver: driver.find_element(by=By.XPATH, value="/html/body/div[9]/div/div[1]/div[2]/div/div/div[1]/div[1]/div[2]/div/div[5]/div[2]/div[4]/div/div/div[2]"))

        submit_button = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=submit_button_xpath))
        submit_button.click()

        post.status = 'published'
        post.save() 

    except Exception as e:
        print(e)
        post.status = 'delayed'
        post.save()
    finally:
        driver.quit()

@time_this
def send_post_to_vkontakte(driver, post):
    url = "https://vk.com/"
    login_button_xpath = "//*[@id='index_login']/div/form/button"
    login_field_xpath = "//*[@name='login']"
    password_field_xpath = "//*[@name='password']"
    post_form_xpath = "//*[@id='post_field']"
    add_image_button_xpath = "//*[@id='page_add_media']/div[1]/a[1]"
    image_upload_field_xpath = "//*[@id='photos_upload_input_729012740_-14']"
    add_video_button_xpath = "//*[@id='page_add_media']/div[1]/a[2]"
    video_upload_field_xpath = "//*[@id='choose_video_upload']/input"
    send_post_button_xpath = "//*[@id='send_post']"

    phone = post.platform.phone_number
    password = post.platform.password
    if phone == '' or password == '':
        return
        
    try:
        driver.get(url)

        login_button = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=login_button_xpath))
        login_button.click()

        login_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=login_field_xpath))
        login_field.send_keys(phone)
        login_field.send_keys(Keys.ENTER)

        password_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=password_field_xpath))
        password_field.send_keys(password)
        password_field.send_keys(Keys.ENTER)

        input = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=post_form_xpath))
        input.clear()
        input.send_keys(post.text)
        if post.media:
            if get_mime_type(post.media) == 'image':
                add_image_button = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=add_image_button_xpath))
                add_image_button.click()
                image_upload_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=image_upload_field_xpath))
                image_upload_field.send_keys(post.media.path)
                WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value="//*[@id='thumbs_edit1']/div/div[1]/div[3]"))
                
            if get_mime_type(post.media) == 'video':
                add_video_button = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=add_video_button_xpath))
                add_video_button.click()
                video_upload_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=video_upload_field_xpath))
                video_upload_field.send_keys(post.media.path)
                WebDriverWait(driver, 60).until(lambda driver: driver.find_element(by=By.XPATH, value="//*[@id='thumbs_edit1']/div/div[1]/div"))

        send_post_button = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=send_post_button_xpath))
        send_post_button.click()

        post.status = 'published'
        post.save()
    except Exception as e:
        print(e)
        post.status = 'delayed'
        post.save()
    finally:
        driver.quit()    


@time_this
def send_post_to_twitter(driver, post):
    url = "https://twitter.com/i/flow/login"
    tweet_url = "https://twitter.com/compose/tweet"
    login_field_xpath = "//*[@id='react-root']/div/div/div/div/div/div/div/div/div/div[2]/div[2]/div/div/div[2]/div[2]/div/div/div/div[5]/label/div/div[2]/div/input"
    phone_field_xpath = "//*[@id='layers']/div/div/div/div/div/div/div[2]/div[2]/div/div/div[2]/div[2]/div[1]/div/div[2]/label/div/div[2]/div/input"
    password_field_xpath = "//*[@id='layers']/div/div/div/div/div/div/div[2]/div[2]/div/div/div[2]/div[2]/div[1]/div/div/div[3]/div/label/div/div[2]/div[1]/input"
    input_field_xpath = "//*[@class='DraftEditor-editorContainer']/div"
    file_field_xpath = "//*[@id='layers']/div[2]/div/div/div/div/div/div[2]/div[2]/div/div/div/div[3]/div/div[1]/div/div/div/div/div[2]/div[3]/div/div/div[1]/input"
    submit_button_xpath = "//*[@id='layers']/div[2]/div/div/div/div/div/div[2]/div[2]/div/div/div/div[3]/div/div[1]/div/div/div/div/div[2]/div[3]/div/div/div[2]/div[4]"

    email = post.platform.email
    password = post.platform.password
    phone = post.platform.phone_number
    # activate_vpn(driver)
    driver.get(url)

    login_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=login_field_xpath))
    login_field.send_keys(email)
    login_field.send_keys(Keys.ENTER)
    
    
    try:
        phone_field = WebDriverWait(driver, 10).until(lambda driver: driver.find_element(by=By.XPATH, value=phone_field_xpath))
        phone_field.send_keys(phone, Keys.ENTER)
    except TimeoutException:
        pass


    password_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.NAME, value="password"))
    password_field.send_keys(password)
    password_field.send_keys(Keys.ENTER)

    # driver.get(tweet_url)
    tweet_button = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value="//*[@id='react-root']/div/div/div[2]/header/div/div/div/div[1]/div[3]/a"))
    tweet_button.click()

    input_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=input_field_xpath))
    input_field.send_keys(post.text)

    if post.media:
        if get_mime_type(post.media) == 'image':
            file_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=file_field_xpath))
            file_field.send_keys(post.media.path)
            
        if get_mime_type(post.media) == 'video':
            file_field = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=file_field_xpath))
            file_field.send_keys(post.media.path)
    print(driver.title)
    submit_button_xpath = WebDriverWait(driver, 15).until(lambda driver: driver.find_element(by=By.XPATH, value=submit_button_xpath))
    submit_button_xpath.click()
    
    WebDriverWait(driver, 60).until_not(EC.url_to_be(tweet_url))

    post.status = 'published'
    post.save()

    driver.quit()

@time_this
def send_post_to_pinterest(post):
    
    login = post.platform.login
    email = post.platform.email
    password = post.platform.password
    if post.media and get_mime_type(post.media) == 'image':
        image_path = post.media.path
    else:
        return


    pinterest = Pinterest(
        email=email,
        password=password,
        username=login,
        cred_root="pin_creds"
        )

    pinterest.login()

    parts = post.text.split('/n', 1)
    title = parts[0]
    description = parts[1] if len(parts) > 1 else ''
        

    pinterest.upload_pin(
        board_id="620230248622142690",
        image_file=image_path,
        description=description,
        title=title,
        )
    
    post.status = 'published'
    post.save()
