from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setup(
    name="telegram-video-compressor",
    version="1.0.0",
    author="TelegramVideoCompressor Contributors",
    author_email="example@example.com",
    description="Comprime video di grandi dimensioni per Telegram mantenendo la massima qualità possibile",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/yourusername/TelegramVideoCompressor",
    packages=find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Topic :: Multimedia :: Video :: Conversion",
    ],
    python_requires=">=3.6",
    entry_points={
        "console_scripts": [
            "telegram-video-compressor-gui=telegram_video_compressor.gui:main",
        ],
    },
    install_requires=[
        # Solo le dipendenze standard sono richieste
        # tkinter è incluso in Python standard
    ],
)
