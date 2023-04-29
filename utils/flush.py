import argparse
import logging
import subprocess


def flush_dns_cache(db_path):
    logging.info("Flushing the DNS cache")
    subprocess.run(["pihole", "flush"])
    subprocess.run(["sudo", "du", db_path, "-h"])


def stop_ftl_service():
    logging.info("Stopping the pihole-FTL service")
    subprocess.run(["sudo", "systemctl", "stop", "pihole-FTL"])


def start_ftl_service():
    logging.info("Starting the pihole-FTL service")
    subprocess.run(["sudo", "systemctl", "start", "pihole-FTL"])


def remove_db_file(db_path):
    logging.info(f"Removing the database file at {db_path}")
    subprocess.run(["sudo", "rm", db_path])


def main():
    parser = argparse.ArgumentParser(description="Flush the DNS cache and reset the pihole-FTL database")
    parser.add_argument("--db-path", default="/etc/pihole/pihole-FTL.db", help="Path to the pihole-FTL database file")
    parser.add_argument("--restart-service", action="store_true", help="Restart the pihole-FTL service")
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

    flush_dns_cache(args.db_path)
    stop_ftl_service()
    remove_db_file(args.db_path)
    if args.restart_service:
        start_ftl_service()

    logging.info("Done!")


if __name__ == "__main__":
    main()
