import httpx

def main():
    # httpx post request
    r = httpx.post('http://localhost:80/water-monitoring/test.php', data={'test': 'test'})
    print(r.text)

main()