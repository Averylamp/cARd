# install the virtual environment

```
python3 -m pip install --user virtualenv
python3 -m virtualenv env
source env/bin/activate
pip install -r requirements.txt
```

# note on rgb vs. bgr

OpenCV loads images to bgr format. This is important when algorithms depend on just one of bgr or rgb. It's also important when saving opencv images, which assume the image to be saved is of type bgr format.

# google vision api resources

- https://cloud.google.com/vision/docs/quickstart-client-libraries#client-libraries-install-python
- setup api_keys.py with GOOGLE_API_KEY = "api-key-as-a-string"