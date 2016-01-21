#!/bin/env python
#
# sysowner - Chuck Moreland
#
##########
#
# important statement
#
import sys, yaml
#
# class SysOwner:
#
class SysOwner:
    # gets config/data
    def __init__(self, debug=False):
        # set debug status
        self.debug = debug
        if self.debug:
            sys.stderr.write("DEBUG: debug set to {debug}".format(debug=debug))

        # load data from config file
        with open('/etc/sysowner/sysowner.yaml', 'r') as config:
            self.data = yaml.load(config)

    def __str__(self):
        return self.data

    #def add_client(self):
    #    for client in self.data['clients']:
    #        self.data['clients']['clients_{client}'.format(client=client)]

    def go(self, command):
        '''
        Run SysOwner go commands
        :param command:
        :return: commands method
        '''
        if self.debug:
            sys.stderr.write('DEBUG: finding command {command}\n'.format(command=command))

        # run module
        return getattr(self, 'go_' + command.upper(), None)

    def go_FACT(self, fact=None):
        '''

        :param fact:
        :return:
        '''
        if self.debug:
            sys.stderr.write('DEBUG: running go_FACT\n')

        # act on fact - fun to say
        if fact in self.data.keys():
            try:
                value = self.data[fact]
                return value
            except ValueError as error:
                sys.stderr.write('Invalid fact - ' + ', '.join(error.args) + '\n')
                return
        else:
            #sys.stderr.write('ERROR: {fact} not a valid fact.\n'.format(fact=fact))
            return

    def go_CONFIG(self):
        '''

        :return:
        '''
        if self.debug:
            sys.stderr.write('DEBUG: running go_CONFIG\n')

        # output yaml
        sys.stdout.write(yaml.dump(self.data))
        return self.data

    def go_UNKNOWN(self):
        '''

        :return:
        '''
        if self.debug:
            sys.stderr.write('DEBUG: running go_UNKNOWN\n')

        raise NotImplementedError, 'unknown command'
#
# main
#
def main():
    '''
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
    if command not in commands:
        print 'ERROR: {name} command not found.'.format(name=command)
        exit()

    # create SysOwner to sysowner commands
    sysowner = SysOwner()

    # SysOwner go processing
    if command == 'fact':
        if len(sys.argv) > 2:
            fact = sys.argv[2]
            value = sysowner.go(command)(fact)
            print '{fact}={value}'.format(fact=fact, value=value)
    elif command == 'config':
        sysowner.go(command)()

if __name__ == "__main__":
    main()
