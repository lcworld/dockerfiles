#!/usr/bin/env bash
set -e

organisation=$1
diacamma_type=$2

echo Organisation: $organisation
echo Type: $diacamma_type

if [ ! -f /var/lucterios2/$organisation/settings.py ]
then
  case "$diacamma_type" in
    asso)
      modules="lucterios.contacts,lucterios.documents,lucterios.mailing,diacamma.accounting,diacamma.payoff,diacamma.event,diacamma.member,diacamma.invoice"
      ;;
    syndic)
      modules="lucterios.contacts,lucterios.documents,lucterios.mailing,diacamma.accounting,diacamma.payoff,diacamma.condominium"
      ;;
    *)
      echo 'Missing type, please set "asso" or "syndic"'
      exit 1
      ;;
  esac
  /var/lucterios2/launch_lucterios.sh add -n $organisation -m "$modules" -p diacamma.$diacamma_type
fi

cd /var/lucterios2
source virtual_for_lucterios/bin/activate
export DJANGO_SETTINGS_MODULE="${organisation}.settings"
exec gunicorn lucterios.framework.wsgi --bind=0.0.0.0:8100 --access-logfile - --error-logfile -

