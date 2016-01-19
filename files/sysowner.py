#!/bin/env python
#
# sysowner - Chuck Moreland @TheChuckMo
#

#
# important statement
#
import sys, yaml
#

def load_facts():
    pass


class SysOwner:
    # gets config/data

    def __init__(self, debug=False):
        self.debug = debug
        if self.debug:
            print "DEBUG: debug set to {debug}".format(debug=debug)

        with open('/etc/sysowner/sysowner.yaml', 'r') as raw:
            self.data = yaml.load(raw)

    def go(self, command):
        if self.debug:
            print 'DEBUG: finding command {command}'.format(command=command)

        return getattr(self, 'go_' + command.upper(), None)

    def go_FACT(self, fact):
        if self.debug:
            print 'DEBUG: running go_FACT'

        if fact in self.data.keys():
            try:
                print '{fact}={value}'.format(fact=fact, value=self.data[fact])

                return self.data[fact]
                #else:
                #    print '{fact}={value}'.format(fact=fact, value=SysOwner.data[fact])
                #    return SysOwner.data[fact]
            except:
                print '{fact}='.format(fact=fact)
                return
        else:
            print 'ERROR: {fact} not a valid fact.'.format(fact=fact)
            return

    def go_CONFIG(self):
        print yaml.dump(self.data)
        return yaml.dump(self.data)

    def go_unknown(self):
        raise NotImplementedError, 'unknown command'


#
# main
#
def main():
    '''
    :param argv:
    :return:
    '''
    # list of valid commands
    commands = ['fact', 'config', ]

    # first argument is the command
    try:
        command = sys.argv[1]
    except:
        print 'ERROR: no command passed'
        print 'valid commands: [' + ', '.join(commands) + ']'
        exit()

    # verify command is supported
    #if command not in commands:
    #    print 'ERROR: {name} command not found.'.format(name=command)
    #    exit()

    # create SysOwner to run commands
    #run = SysOwner(debug=True)
    run = SysOwner()

    # run SysOwner processing
    if command == 'fact':
        run.go(command)(sys.argv[2])
    elif command == 'config':
        run.go(command)()

if __name__ == "__main__":
    main()
