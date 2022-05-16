from multiprocessing.sharedctypes import Value
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.proxy import *
from selenium.webdriver.common.keys import Keys
from concurrent import futures
import time
from .models import PlatformPost


# decorator for measuring elapsed time
def time_this(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start} seconds")
        return result
    return wrapper


def initialize_driver():
    # TODO: run driver in another process
    # TODO: add proxy

    PROXY = "195.181.174.139:3128"
    proxy_url = "72.221.196.157:35904"
    proxy = Proxy({
    'proxyType': ProxyType.MANUAL,
    'httpProxy': proxy_url,
    'sslProxy': proxy_url,
    'ftpProxy': proxy_url,
    'noProxy': ''})
    capabilities = webdriver.DesiredCapabilities.CHROME
    # proxy.add_to_capabilities(capabilities)

    options = webdriver.ChromeOptions()
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--ignore-ssl-errors')
    options.add_experimental_option('excludeSwitches', ['enable-logging'])
    options.add_argument('--headless')
    # options.add_argument(f"--proxy-server={proxy_url}")
    driver  = webdriver.Chrome(options=options, desired_capabilities=capabilities)

    return driver


def log_post(post):
    # log post to text file
    with open('post_log.txt', 'a') as f:
        f.write(f"Created post # {post.id}\n")
        f.write(f"Current status: {post.status}\n")
        f.write(f"Platform: {post.platform.platform}\n")
        f.write(f"Phone: {post.platform.phone_number}\n")
        f.write(f"Password: {post.platform.password}\n")

@time_this
def send_post(post):
    # send post to platform
    driver = initialize_driver()
    if post.platform.platform == 'OK':
        send_post_to_odnoklassniki(driver, post)
    if post.platform.platform == 'VK':
        send_post_to_vkontakte(driver, post)

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
    driver.find_element(by=By.XPATH, value="//*[@class='posting_f_ac']/div[2]").click()
    time.sleep(4)


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
    time.sleep(2)
    driver.find_element(by=By.XPATH, value="//*[@id='send_post']").click()
    time.sleep(3)


@time_this
def send_post_experimental(post):
    platform_posts = PlatformPost.objects.filter(post=post)
    with futures.ThreadPoolExecutor() as executor:
        executor.map(send_post_to_platform, platform_posts)

@time_this
def send_post_to_platform(platform_post):
    driver = initialize_driver()
    if platform_post.platform.platform == 'OK':
        send_post_to_odnoklassniki(driver, platform_post)
    if platform_post.platform.platform == 'VK':
        send_post_to_vkontakte(driver, platform_post)
    driver.quit()
